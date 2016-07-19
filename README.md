# hyql-finance
Interfacing YQL/Yahoo Finance Stocks prices with Haskell

## License ##
GNU GENERAL PUBLIC LICENSE Version 2, June 1991

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

[Full license](https://github.com/mkarpis/hyql-finance/blob/master/LICENSE.md)

## About ##
hyql-finance is a simple Haskell library for querying [Yahoo Finance API] (http://query.yahooapis.com/v1/test/console.html).

Currently supported features:
* Only select queries (no authentication)

## Install ##
Application is packed as a Cabal package (package and build system for Haskell). So after cloning repo into your directory you can install it with:
```sh
$ cabal install
```

## Usage ##
### Retrieving stock features ###
To add/remove features, which you would like to get returned just uncomment/comment feature from the Stock Data (example below).

```sh
data  Stock = Stock {
    symbol :: String,
    percentChange :: String
 --   volume :: Int,
 --   openPrice :: Double,
 --   highPrice :: Double,
 --   lowPrice :: Double,
 --   closePrice :: Double,
 --   percChange :: Double
} deriving (Eq, Show)
```

### Defining stocks ###
To add/remove stock, which you would like to get data from just add/remove them from Symbols list (example below).

```sh
symbols :: [String]
symbols = ["\'AAPL\'", "\'GOOG\'"]
```

## Bugs & Feature requests ##
Please log all bugs and feature requests to the githubs [Issues Tracker](https://github.com/mkarpis/hyql-finance/issues) 
