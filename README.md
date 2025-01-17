# Keep 2 Todoist

[![Test Status](https://github.com/jo-hoe/keep2todoist/workflows/test/badge.svg)](https://github.com/jo-hoe/keep2todoist/actions?workflow=test)

This repository is provides a K8s chart for [keep2todoist](https://github.com/flecmart/keep2todoist) by [flecmart](https://github.com/flecmart).

## 🚧 Work in Progress

Implementation is currently on hold as an App password is required for the login.
This App password is essentially a master token that provides access to the full google account.
I consider the creation and usage of this token to risky as is provides access to the account with less security measures in place (missing 2FA, limitless access, predefined password entropy).
