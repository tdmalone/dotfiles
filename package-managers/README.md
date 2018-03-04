# Lists of typically installed software

* **[apt-get](apt.txt)**<br />
  To generate run `apt list --installed | grep -v 'Listing...' > apt-list.txt`

* **[Chocolatey](choco.txt)**<br />
  To generate run `choco list --local-only > choco-list.txt`

* **[Composer](composer.txt)**<br />
  To generate run `composer global show > composer-list.txt`

* **[Homebrew](brew.txt)**<br />
  To generate run `brew list > brew-list.txt`

* **[pip](pip.txt)**<br />
  To generate run `pip list > pip-list.txt` (or potentially `pip3 list > pip-list.txt`)

* **[RubyGems](gem.txt)**<br />
  To generate run `gem list > gem-list.txt`

* **[Yarn/npm](yarn.txt)**<br />
  To generate run `yarn global list --json --no-progress | grep '"type":"list"' > yarn-list.txt`

* **[yum](yum.txt)**<br />
  To generate run `yum list installed --quiet | grep -v 'Installed Packages' > yum-list.txt`
