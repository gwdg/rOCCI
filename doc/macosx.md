# rOCCI on Mac OS X

## Installation

To use a recent version of Ruby on Mac OS X, a few preparations are needed. Installing Ruby on Apple Mac OS X is not as 
straightforward as it is on other platforms, hence following detailed instructions.

1. Install the latest version of Xcode either
[from the Mac OS X App Store](itms://itunes.apple.com/de/app/xcode/id497799835?mt=12#) or by downloading it from
[[http://developer.apple.com]] and then installing the package.
2. Open Xcode, then download and install the Xcode command line tools (Menu->Xcode->Preferences->Downloads)
3. In the Terminal, install RVM with `curl -L https://get.rvm.io | bash -s stable`
4. Read the plattform requirements for your specific setup by running `rvm requirements` in the Terminal. Execute any
tasks mentioned there for installing Ruby 1.9.3 (you can ignore hints for Ruby 1.8.7). If you need to install additional
packages it is recommended to use Homebew for it (unless you already use MacPorts). To install Homebrew paste the
following in your Terminal `ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"`
5. Install Ruby 1.9.3 with `rvm install ruby-1.9.3`

Now that you have Ruby 1.9.3 installed, you can intall rOCCI.

To install the most recent stable version

    gem install occi

To install the most recent beta version

    gem install occi --pre
