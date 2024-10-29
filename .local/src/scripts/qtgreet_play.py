import sys
import argparse
from pathlib import Path
from string import Template
import subprocess
from time import sleep

def runCommand(command, skip_out=False, skip_err=False):
    p = subprocess.Popen(command,
                         stdout=subprocess.PIPE,
                         stderr=subprocess.PIPE,
                         shell=True)
    if not skip_out:
        for line in iter(p.stdout.readline, b''):
            line = line.strip()
            if line:
                print(line.decode("utf-8"))

    while p.poll() is None:
        sleep(.1)
    ret = p.returncode

    if not skip_err:
        err = p.stderr.read()
        if ret != 0:
           print(f"Error ({ret}): {err.decode("utf-8")}")

    return ret

def getTmpDownloadDir(dirname=""):
    dwnld_dirname = Path("qtgreet_vids") / dirname
    dwnld_dir = Path.home() / ".cache"
    if not dwnld_dir.is_dir():
        dwnld_dir = Path("/tmp")

    dwnld_dir = dwnld_dir / dwnld_dirname
    return dwnld_dir

if __name__ == "__main__":

    parser = argparse.ArgumentParser(prog='Qtgreet video downloader', usage='%(prog)s [options]')
    parser.add_argument('input', type=str, help="The path of the file to read.")
    parser.add_argument('-o', '--outdir', type=str, default="", help="The path to output directory")
    parser.add_argument('--noplay', action="store_true", help="Don't play the video using mpv")
    parser.add_argument('--download', action="store_true", help='Download the video using yt-dlp')

    if len(sys.argv)==1:
        parser.print_help(sys.stderr)
        sys.exit(1)

    args = parser.parse_args()

    in_file = Path(args.input)

    if args.outdir:
        dwnld_dir = Path(args.outdir)
    else:
        dwnld_dir = getTmpDownloadDir(in_file.stem)

    dwnld_dir.mkdir(parents=True, exist_ok=True)

    cmd_fmt = "mpv --no-config --really-quiet --terminal=no {arg}"
    cmd_dwnld_fmt = Template('yt-dlp -o "$dwnld_dir/%(title)s.%(ext)s" $arg').safe_substitute({"dwnld_dir" : dwnld_dir})

    with in_file.open('r') as f:
        for url in f:
            url = url.strip()
            downloaded = False

            if not args.noplay:
                print(f"\nPlaying {url}")
                cmd = cmd_fmt.format(arg=url)
                ret = runCommand(cmd, skip_out=True)

                if ret == 0 and args.download:
                    downloaded = True
                    print(f"\nDownloading {url} to {dwnld_dir}")
                    cmd_dwnld = Template(cmd_dwnld_fmt).substitute({"arg" : url})
                    runCommand(cmd_dwnld)

            if not downloaded and args.download:
                print(f"\nDownloading {url} to {dwnld_dir}")
                cmd_dwnld = Template(cmd_dwnld_fmt).substitute({"arg" : url})
                runCommand(cmd_dwnld)
