{-# LANGUAGE OverloadedStrings, DeriveGeneric #-}
{-# LANGUAGE ScopedTypeVariables #-}


module HYQLFinance(
  symbols,
  yqlParams,
  yqlBuildUrl,
  httpExceptionHandler,
  getYqlXML,
  getElementFromXML,
  findStringsInElement,
  getStocksFromElement,
  refreshStocks
)where

--import Control.Monad
import Network.HTTP.Conduit
import qualified Data.ByteString.Lazy as L
import Text.XML.Light
import Control.Exception as Exc
import Data.List.Utils as Utils (join) 

getFinanceData :: IO ()
getFinanceData = do
  putStrLn "getting finance data"



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



symbols :: [String]
symbols = ["\'AAPL\'", "\'GOOG\'"]

yqlParams :: [String]
yqlParams = ["Symbol", "Open", "PreviousClose", "PercentChange", "Volume", "AskRealtime", "DaysHigh", "DaysLow"]


-- | Build YQL Yahoo.Finance url string based on given parameters and symbols (of stocks)
yqlBuildUrl :: [String] -> [String] -> String
yqlBuildUrl paramsIn symbolsIn
  | null paramsIn = ""
  | null symbolsIn = ""
  | otherwise = baseUrl ++ params ++ urlMiddle ++ symbols ++ urlEnd
    where 
      params = Utils.join ", " paramsIn
      symbols = Utils.join ", " symbolsIn
      baseUrl = "http://query.yahooapis.com/v1/public/yql?q=select "
      urlMiddle = " from yahoo.finance.quotes where symbol in ("
      urlEnd = ")&env=store://datatables.org/alltableswithkeys"


-- | Exception handler for simpleHttp
httpExceptionHandler ::  HttpException -> IO L.ByteString
httpExceptionHandler e = (putStrLn $ "Error: simpleHttp returned exception " ++ show e) >> (return L.empty)


-- | Get data from given url. Function will return empty Bytestring if exception occured
getYqlXML :: String -> IO L.ByteString
getYqlXML url = (simpleHttp url) `Exc.catch` httpExceptionHandler  


-- | Parses raw XML into Element
getElementFromXML :: L.ByteString -> Either String Element
getElementFromXML xmlData
  | xmlData == L.empty = Left "getStocksFromXML: received empty input data!"
  | otherwise =
      case parseXMLDoc xmlData of
        Nothing -> Left "getStocksFromXML: error parsing content"
        Just xmlElement -> Right xmlElement

-- | Find given String in Element. As a return is list of XML tags content
findStringsInElement :: Element -> String -> [String]
findStringsInElement el name 
  | name == [] = []
  | otherwise = x
      where
        x = [cdData titleContent | [Text titleContent] <- [elContent element | element <- elements]]
          where 
            elements = findElements (unqual name) $ el

-- | Parses given Element into a Stock list
getStocksFromElement :: Element -> [Stock]
getStocksFromElement el = zipWith Stock stocks percentChanges
    where
      stocks = findStringsInElement el "Symbol"
      percentChanges = findStringsInElement el "PercentChange"


-- | Function will return list of Stocks from Yahoo.Finance server
refreshStocks :: IO (Either String [Stock])
refreshStocks = do
  let yqlQuery = yqlBuildUrl yqlParams symbols
  --putStrLn $ "querying: " ++ show yqlQuery
  yqlXML <- getYqlXML yqlQuery
  if yqlXML == L.empty
    then return $ Left "getYqlXML: error getting XML!" 
    else do
      case getElementFromXML yqlXML of
        Left msg -> return $ Left msg
        Right el -> do
          let stocks = getStocksFromElement el
          return $ Right stocks












