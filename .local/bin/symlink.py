#!/usr/bin/env python3

__author__ = "Akhil Mithran"
__maintainer__ = "AkhilCM"
__email__ = "mithran@fias.uni-frankfurt.de"

import os
import stat
import shutil
import argparse
from pathlib import Path

def getCleanPath(path) :
    # clean_path = Path(path).absolute()
    clean_path = os.path.abspath(os.path.expanduser(os.path.expandvars(path)))
    return Path(clean_path)

def removePath(path, mode) :
    path = getCleanPath(path)
    if stat.S_ISDIR(mode) :
        shutil.rmtree(path)
    else:
        path.unlink()

def validatePaths(source, target) :
    if not source.exists() :
        print(f"[Error]:- Invalid arguments provided.\nSource does not exist:-\n{source}")
        exit(1)
    source_mode = source.lstat().st_mode
    target_mode = None
    if target.exists() :
        target_mode = target.lstat().st_mode
        if stat.S_ISREG(source_mode) and stat.S_ISDIR(target_mode) :
            print(f"[Error]:- Invalid arguments provided.\nSource is a file:-\n{source}Target is a directory:-\n{target}")
            exit(1)
        elif stat.S_ISDIR(source_mode) and stat.S_ISREG(target_mode) :
            print(f"[Error]:- Invalid arguments provided.\nSource is a directory:-\n{source}Target is a file:-\n{target}")
            exit(1)
    else:
        target_parent = target.parent
        if target_parent.exists() :
            target_parent_mode = target_parent.lstat().st_mode
            if not stat.S_ISDIR(target_parent_mode) :
                print(f"[Error]:- Invalid arguments provided.\nTarget's parent is a file:-\n{target_parent}")
                exit(1)
    return source_mode, target_mode

def createSymlink(source, target, target_mode, args, totalN, linkN, skipN):
    totalN += 1
    if not target_mode and target.exists() :
        target_mode = target.lstat().st_mode
    if target_mode :
        if args.skip:
            print(f"Skipping link to existing target: {target} -> {source}")
            skipN += 1
            return totalN, linkN, skipN
        if args.force:
            removePath(target, target_mode)
        else:
            response = input(f"{target} already exists. Overwrite? (y/n): ").lower()
            if response == 'y':
                removePath(target, target_mode)
            else:
                print(f"Skipping link to existing target: {target} -> {source}")
                skipN += 1
                return totalN, linkN, skipN

    if args.hardlink :
        os.link(source, target)
    else:
        os.symlink(source, target)
    print(f"Symlink created: {target} -> {source}")
    linkN += 1
    return totalN, linkN, skipN

def recursiveSymlink(source_dir, target_dir, target_dir_mode, args, totalN, linkN, skipN):
    if not target_dir_mode :
        target_dir.mkdir(parents=False, exist_ok=False)
    for root, dirs, files in os.walk(source_dir):
        relative_dir = os.path.relpath(root, start=source_dir)
        target_dir_current = target_dir / relative_dir
        target_dir_current.mkdir(parents=False, exist_ok=True)
        source_dir_current = Path(root)
        if args.relative :
            source_dir_current = Path( os.path.relpath(root, start=target_dir_current) )

        for file in files:
            source = source_dir_current / file
            target = target_dir_current / file
            totalN, linkN, skipN = createSymlink(source, target, None, args, totalN, linkN, skipN)

    return totalN, linkN, skipN

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Create symlinks.")
    parser.add_argument("source", help="Source file or directory")
    parser.add_argument("target", help="target symlink")
    parser.add_argument("-R", "--relative", action="store_true", help="Create a relative symlink")
    parser.add_argument("-A", "--absolute", action="store_false", help="Create an absolute symlink (default)")
    parser.add_argument("-r", "--recursive", action="store_true", help="Recursively symlink files in directories")
    parser.add_argument("-f", "--force", action="store_true", help="Force overwrite existing targets with same name")
    parser.add_argument("-S", "--skip", action="store_true", help="Skip if target with same name already exists")
    parser.add_argument("-p", "--parents", action="store_true", help="Create missing parent directories")
    parser.add_argument("-H", "--hardlinks", action="store_true", help="Create hard links instead of soft links")
    parser.add_argument("-F", "--follow", action="store_true", help="Resolve to the linked location when using a symlink as source")
    args = parser.parse_args()

    source_path = getCleanPath(args.source)
    target_path = getCleanPath(args.target)
    source_mode, target_mode = validatePaths(source_path, target_path)
    if stat.S_ISLNK(source_mode) and args.follow :
        source_path = source_path.resolve()
        source_mode = source_path.lstat().st_mode

    target_parent = target_path.parent
    if not target_parent.exists() and not args.parents :
        print(f"[Error]:- Target's parent directory does not exist:-\n{target_parent}\nUse -p/--parents flag to create missing parent directories.")
        exit(1)
    target_parent.mkdir(parents=True, exist_ok=True)

    totalN = linkedN = skippedN = 0
    if args.recursive and stat.S_ISDIR(source_mode) :
        totalN, linkedN, skippedN = recursiveSymlink(source_path, target_path, target_mode, args, totalN, linkedN, skippedN)
    elif stat.S_ISDIR(source_mode) or stat.S_ISREG(source_mode) :
        if args.relative :
            source_path = Path( os.path.relpath(source_path, start=target_parent) )
        totalN, linkedN, skippedN = createSymlink(source_path, target_path, target_mode, args, totalN, linkedN, skippedN)
    else :
        print(f"[Error]:- Could not create symlink. Unimplemented source type.\nSource :-\n{source_path}\nTarget :- {target_path}")
        exit(1)

    print("\n[Info]:- symlink.py Symlinking completed.")
    print(f"[Info]:- Total number of entries - {totalN}")
    print(f"[Info]:- Total number of links created - {linkedN}")
    print(f"[Info]:- Total number of links skipped - {skippedN}")
