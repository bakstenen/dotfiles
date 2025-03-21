import sys
import re
from typing import Union, Tuple
import logging
from pathlb import Path

import argparse

GIT_FOLDER = '.git'
RE_CLASS_PY = re.compile(r'^class\s+(?P<name>\w+)')
RE_METHOD_PY = re.compile(r'^(?P<indent>\s*)def(?P<name>\w+)')

logger = logging.getLogger(__name__)


def _git_root(path:Path) -> Union[None, Path]:
    test = path / GIT_FOLDER
    if test.exists():
        return path
    if path.parent == path:
        return None
    return _git_root(path.parent)


def _absolute_test_path(raw_path:str) -> Union[None, Path]:
    path = None
    if (  # absolute path or relative to pwd
        raw_path.startswith('.') or
        raw_path.startswith('/') 
    ):
        path = Path(raw_path)
    else:  # try and find relative to git repo
        cwd = Path('.').resolve()
        git_root = _git_root(cwd)
        if git_root is None:
            return None

        path = git_root / raw_path

    path = path.resolve()
    if not path.exists():
        return None
    return path


def _find_test_case_py(
    path:Path, line_no:Union[None, int]
) -> Tuple[Union[None, str], Union[None, str]]:
    test_prefix = 'test_'

    test_class_hold = None
    test_class = None
    test_method = None

    with open(str(path), 'r') as f:
        for n, line in enumerate(f.readlines()):
            if n >= line_no:
                break

            class_match = RE_CLASS_PY.match(line)
            if class_match is not None:
                test_class_hold = class_match.group('name')
                test_class = None
            method_match = RE_METHOD_PY.match(line)
            if method_match is None:
                continue

            indent = method_match.group('indent')
            name = method_match.group('name')

            if len(indent) == 0:
                test_class_hold = None
                test_class = None

            if not name.startswith(test_prefix):
                continue

            if any(indent == i for i in ('    ', '\t')):
                test_class = test_class_hold
            test_method = name

    return test_class, test_method


def _find_test_case(
    path:Path, line_no: int
) -> Tuple[Union[None, str], Union[None, str]]:
    if path.suffix in ('.py',):
        return _find_test_case_py(path, line_no)
    return None, None


def main(raw_path:str, line_no:Union[None, int]):
    # find absolute path to the test file
    path = _absolute_test_path(raw_path)
    if path is None:
        logger.warning(f'Could not resolve raw path: {raw_path}')
        return 1

    git_path = _git_root(path)

    # find test class and method within test file
    test_class = test_method = None
    if line_no >= 0:
        test_class, test_method = _find_test_case(path, line_no)
        if test_method is None:
            logger.warning(f'Could not find method at: {raw_path}:{line_no}')
            return 1
        
    # assemble full test path
    case_path = str(path.relative_to(git_path))
    for part in (test_class, test_method):
        if part is not None:
            case_path += f'::{part}'

    # output to stdio
    print(case_path)

    return 0


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument(
        '--path',
        help='Path to the test file',
        dest='raw_path',
        type=str,
        required=True
    )
    parser.add_argument(
        '--line',
        help='Line number from where to search for the test',
        dest='line_no',
        type=int,
        default=-1,
        required=False
    )
    parser.add_argument(
        '--log-level',
        help='log level for the process',
        dest='log_level',
        type=str,
        default='info',
        required=False
    )
    parsed = parser.parse_args()
    kwargs = dict((k, v) for k, v in parsed._get_kwargs())

    log_level = {
        'debug': logging.DEBUG,
        'info': logging.INFO,
        'warning': logging.WARNING,
        'error': logging.ERROR,
        'critical': logging.CRITICAL,
    }.get(kwargs.pop('log_level', 'info'), logging.INFO)

    logging.basicConfig(level=log_level, stream=sys.stderr)

    sys.exit(main(**kwargs))
