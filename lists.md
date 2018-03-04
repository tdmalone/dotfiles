# Lists of typically installed software

* **[apt-get](apt-list.txt)**<br />
  To generate run `apt list --installed | grep -v 'Listing...' > apt-list.txt`

* **[Chocolatey](choco-list.txt)**<br />
  To generate run `choco list --local-only > choco-list.txt`

* **[Composer](composer-list.txt)**<br />
  To generate run `composer global show > composer-list.txt`

* **[Homebrew](brew-list.txt)**<br />
  To generate run `brew list > brew-list.txt`

* **[pip](pip-list.txt)**<br />
  To generate run `pip list > pip-list.txt` (or potentially `pip3 list > pip-list.txt`)

* **[RubyGems](gem-list.txt)**<br />
  To generate run `gem list > gem-list.txt`

* **[Yarn/npm](yarn-list.txt)**<br />
  To generate run `yarn global list --json --no-progress | grep '"type":"list"' > yarn-list.txt`

* **[yum](yum-list.txt)**<br />
  To generate run `yum list installed --quiet > yum-list.txt`
