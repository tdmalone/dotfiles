# Lists of typically installed software

* **[apt-get](apt.txt)**<br />
  To generate run `apt list --installed | grep -v 'Listing...' > apt.txt`

* **Chocolatey**<br />
  Coming soon (maybe)<br />
  To generate run `choco list --local-only > choco.txt`

* **[Composer](composer.json)**<br />
  Automatically managed via symlink<br />
  To generate manually run `composer global show > composer.txt`

* **[Homebrew](brew.txt)**<br />
  To generate run `brew list > brew.txt`

* **[pip](pip.txt)**<br />
  To generate run `pip list > pip.txt` (or potentially `pip3 list > pip.txt`)

* **[RubyGems](gem.txt)**<br />
  To generate run `gem list > gem.txt`

* **[Yarn/npm](package.json)**<br />
  Automatically managed via symlink<br />
  To generate manually run `yarn global list --json --no-progress | grep '"type":"list"' > yarn.txt`

* **[yum](yum.txt)**<br />
  To generate run `yum list installed --quiet | grep -v 'Installed Packages' > yum.txt`
