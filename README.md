# homebrew-tools
A homebrew tap  

Usage(macOS):  
`brew tap akashagarwal7/tools`

After adding the tap, you must run `brew update` so that the formulae present in this repo are available for you to install.

## Updating the tsay formula

1. Run `./update_tsay_sha256.sh <version>` to update the Homebrew ruby file.
2. Commit and push changes.
3. Run `brew install akashagarwal7/tools/tsay` on your machine to update `tsay` selectively.
