# Caching and offline workflows

``` r
library(mongolstats)
```

## Enable cache

Cache speeds up repeated calls to table listings and metadata. You can
also set a TTL.

``` r
dir <- tryCatch(nso_cache_enable(ttl = 7 * 24 * 3600), error = function(e) NULL)
dir
```

    ## [1] "~/.cache/mongolstats/v1"

## Inspect cache status

``` r
nso_cache_status()
```

    ## $enabled
    ## [1] TRUE
    ## 
    ## $dir
    ## [1] "~/.cache/mongolstats/v1"
    ## 
    ## $has_cache
    ## [1] TRUE

## Offline mode

Offline mode prevents network requests. Cached metadata remains
available, but data fetches requiring the network will error with a
clear message.

``` r
nso_offline_enable()

# This will use cache if available; otherwise it will error due to offline mode
itms <- try(nso_itms(), silent = TRUE)
itms
```

    ##                                                                                                                                                        px_path
    ## 1                                                                                                                     Economy, environment/Balance of Payments
    ## 2                                                                                                                    Economy, environment/Consumer Price Index
    ## 3                                                                                                                    Economy, environment/Consumer Price Index
    ## 4                                                                                                                    Economy, environment/Consumer Price Index
    ## 5                                                                                                                    Economy, environment/Consumer Price Index
    ## 6                                                                                                                    Economy, environment/Consumer Price Index
    ## 7                                                                                                                    Economy, environment/Consumer Price Index
    ## 8                                                                                                                    Economy, environment/Consumer Price Index
    ## 9                                                                                                                    Economy, environment/Consumer Price Index
    ## 10                                                                                                                   Economy, environment/Consumer Price Index
    ## 11                                                                                                                   Economy, environment/Consumer Price Index
    ## 12                                                                                                                   Economy, environment/Consumer Price Index
    ## 13                                                                                                                   Economy, environment/Consumer Price Index
    ## 14                                                                                                                   Economy, environment/Consumer Price Index
    ## 15                                                                                                                   Economy, environment/Consumer Price Index
    ## 16                                                                                                                   Economy, environment/Consumer Price Index
    ## 17                                                                                                                   Economy, environment/Consumer Price Index
    ## 18                                                                                                                   Economy, environment/Consumer Price Index
    ## 19                                                                                                                   Economy, environment/Consumer Price Index
    ## 20                                                                                                                   Economy, environment/Consumer Price Index
    ## 21                                                                                                                   Economy, environment/Consumer Price Index
    ## 22                                                                                                                   Economy, environment/Consumer Price Index
    ## 23                                                                                                                            Economy, environment/Environment
    ## 24                                                                                                                            Economy, environment/Environment
    ## 25                                                                                                                            Economy, environment/Environment
    ## 26                                                                                                                            Economy, environment/Environment
    ## 27                                                                                                                            Economy, environment/Environment
    ## 28                                                                                                                            Economy, environment/Environment
    ## 29                                                                                                                            Economy, environment/Environment
    ## 30                                                                                                                            Economy, environment/Environment
    ## 31                                                                                                                            Economy, environment/Environment
    ## 32                                                                                                                            Economy, environment/Environment
    ## 33                                                                                                                            Economy, environment/Environment
    ## 34                                                                                                                            Economy, environment/Environment
    ## 35                                                                                                                            Economy, environment/Environment
    ## 36                                                                                                                            Economy, environment/Environment
    ## 37                                                                                                                            Economy, environment/Environment
    ## 38                                                                                                                            Economy, environment/Environment
    ## 39                                                                                                                            Economy, environment/Environment
    ## 40                                                                                                                            Economy, environment/Environment
    ## 41                                                                                                         Economy, environment/Environmental-Economic Account
    ## 42                                                                                                         Economy, environment/Environmental-Economic Account
    ## 43                                                                                                         Economy, environment/Environmental-Economic Account
    ## 44                                                                                                         Economy, environment/Environmental-Economic Account
    ## 45                                                                                                         Economy, environment/Environmental-Economic Account
    ## 46                                                                                                         Economy, environment/Environmental-Economic Account
    ## 47                                                                                                         Economy, environment/Environmental-Economic Account
    ## 48                                                                                                         Economy, environment/Environmental-Economic Account
    ## 49                                                                                                         Economy, environment/Environmental-Economic Account
    ## 50                                                                                                         Economy, environment/Environmental-Economic Account
    ## 51                                                                                                         Economy, environment/Environmental-Economic Account
    ## 52                                                                                                         Economy, environment/Environmental-Economic Account
    ## 53                                                                                                         Economy, environment/Environmental-Economic Account
    ## 54                                                                                                         Economy, environment/Environmental-Economic Account
    ## 55                                                                                                         Economy, environment/Environmental-Economic Account
    ## 56                                                                                                         Economy, environment/Environmental-Economic Account
    ## 57                                                                                                         Economy, environment/Environmental-Economic Account
    ## 58                                                                                                         Economy, environment/Environmental-Economic Account
    ## 59                                                                                                                          Economy, environment/Foreign Trade
    ## 60                                                                                                                          Economy, environment/Foreign Trade
    ## 61                                                                                                                          Economy, environment/Foreign Trade
    ## 62                                                                                                                          Economy, environment/Foreign Trade
    ## 63                                                                                                                          Economy, environment/Foreign Trade
    ## 64                                                                                                                          Economy, environment/Foreign Trade
    ## 65                                                                                                                          Economy, environment/Foreign Trade
    ## 66                                                                                                                          Economy, environment/Foreign Trade
    ## 67                                                                                                                          Economy, environment/Foreign Trade
    ## 68                                                                                                                          Economy, environment/Foreign Trade
    ## 69                                                                                                                          Economy, environment/Foreign Trade
    ## 70                                                                                                                          Economy, environment/Foreign Trade
    ## 71                                                                                                                          Economy, environment/Foreign Trade
    ## 72                                                                                                                          Economy, environment/Foreign Trade
    ## 73                                                                                                                          Economy, environment/Foreign Trade
    ## 74                                                                                                                          Economy, environment/Foreign Trade
    ## 75                                                                                                                          Economy, environment/Foreign Trade
    ## 76                                                                                                                      Economy, environment/Government budget
    ## 77                                                                                                                      Economy, environment/Government budget
    ## 78                                                                                                                      Economy, environment/Government budget
    ## 79                                                                                                                      Economy, environment/Government budget
    ## 80                                                                                                                      Economy, environment/Government budget
    ## 81                                                                                                                      Economy, environment/Government budget
    ## 82                                                                                                                      Economy, environment/Government budget
    ## 83                                                                                                                      Economy, environment/Government budget
    ## 84                                                                                                                      Economy, environment/Government budget
    ## 85                                                                                                                      Economy, environment/Government budget
    ## 86                                                                                                                      Economy, environment/Government budget
    ## 87                                                                                                                      Economy, environment/Government budget
    ## 88                                                                                                                      Economy, environment/Government budget
    ## 89                                                                                                                      Economy, environment/Government budget
    ## 90                                                                                                                      Economy, environment/Government budget
    ## 91                                                                                                                    Economy, environment/Housing price index
    ## 92                                                                                                                    Economy, environment/Housing price index
    ## 93                                                                                                                    Economy, environment/Housing price index
    ## 94                                                                                                                    Economy, environment/Housing price index
    ## 95                                                                                                                    Economy, environment/Housing price index
    ## 96                                                                                                                    Economy, environment/Housing price index
    ## 97                                                                                                                             Economy, environment/Investment
    ## 98                                                                                                                             Economy, environment/Investment
    ## 99                                                                                                                             Economy, environment/Investment
    ## 100                                                                                                                            Economy, environment/Investment
    ## 101                                                                                                                            Economy, environment/Investment
    ## 102                                                                                                                            Economy, environment/Investment
    ## 103                                                                                                                            Economy, environment/Investment
    ## 104                                                                                                                            Economy, environment/Investment
    ## 105                                                                                                                            Economy, environment/Investment
    ## 106                                                                                                                            Economy, environment/Investment
    ## 107                                                                                                                            Economy, environment/Investment
    ## 108                                                                                                                            Economy, environment/Investment
    ## 109                                                                                                                     Economy, environment/Money and Finance
    ## 110                                                                                                                     Economy, environment/Money and Finance
    ## 111                                                                                                                     Economy, environment/Money and Finance
    ## 112                                                                                                                     Economy, environment/Money and Finance
    ## 113                                                                                                                     Economy, environment/Money and Finance
    ## 114                                                                                                                     Economy, environment/Money and Finance
    ## 115                                                                                                                     Economy, environment/Money and Finance
    ## 116                                                                                                                     Economy, environment/Money and Finance
    ## 117                                                                                                                     Economy, environment/Money and Finance
    ## 118                                                                                                                     Economy, environment/Money and Finance
    ## 119                                                                                                                     Economy, environment/Money and Finance
    ## 120                                                                                                                     Economy, environment/Money and Finance
    ## 121                                                                                                                     Economy, environment/Money and Finance
    ## 122                                                                                                                     Economy, environment/Money and Finance
    ## 123                                                                                                                     Economy, environment/Money and Finance
    ## 124                                                                                                                     Economy, environment/Money and Finance
    ## 125                                                                                                                     Economy, environment/Money and Finance
    ## 126                                                                                                                     Economy, environment/Money and Finance
    ## 127                                                                                                                     Economy, environment/Money and Finance
    ## 128                                                                                                                     Economy, environment/Money and Finance
    ## 129                                                                                                                     Economy, environment/Money and Finance
    ## 130                                                                                                                     Economy, environment/National Accounts
    ## 131                                                                                                                     Economy, environment/National Accounts
    ## 132                                                                                                                     Economy, environment/National Accounts
    ## 133                                                                                                                     Economy, environment/National Accounts
    ## 134                                                                                                                     Economy, environment/National Accounts
    ## 135                                                                                                                     Economy, environment/National Accounts
    ## 136                                                                                                                     Economy, environment/National Accounts
    ## 137                                                                                                                     Economy, environment/National Accounts
    ## 138                                                                                                                     Economy, environment/National Accounts
    ## 139                                                                                                                     Economy, environment/National Accounts
    ## 140                                                                                                                     Economy, environment/National Accounts
    ## 141                                                                                                                     Economy, environment/National Accounts
    ## 142                                                                                                                     Economy, environment/National Accounts
    ## 143                                                                                                                     Economy, environment/National Accounts
    ## 144                                                                                                                     Economy, environment/National Accounts
    ## 145                                                                                                                     Economy, environment/National Accounts
    ## 146                                                                                                                     Economy, environment/National Accounts
    ## 147                                                                                                                     Economy, environment/National Accounts
    ## 148                                                                                                                     Economy, environment/National Accounts
    ## 149                                                                                                                     Economy, environment/National Accounts
    ## 150                                                                                                                     Economy, environment/National Accounts
    ## 151                                                                                                                     Economy, environment/National Accounts
    ## 152                                                                                                                     Economy, environment/National Accounts
    ## 153                                                                                                                     Economy, environment/National Accounts
    ## 154                                                                                                                     Economy, environment/National Accounts
    ## 155                                                                                                                          Economy, environment/Productivity
    ## 156                                                                                                                          Economy, environment/Productivity
    ## 157                                                                                                                          Economy, environment/Productivity
    ## 158                                                                                                                           Education, health/Births, deaths
    ## 159                                                                                                                           Education, health/Births, deaths
    ## 160                                                                                                                           Education, health/Births, deaths
    ## 161                                                                                                                           Education, health/Births, deaths
    ## 162                                                                                                                           Education, health/Births, deaths
    ## 163                                                                                                                           Education, health/Births, deaths
    ## 164                                                                                                                           Education, health/Births, deaths
    ## 165                                                                                                                           Education, health/Births, deaths
    ## 166                                                                                                                           Education, health/Births, deaths
    ## 167                                                                                                                           Education, health/Births, deaths
    ## 168                                                                                                                           Education, health/Births, deaths
    ## 169                                                                                                                           Education, health/Births, deaths
    ## 170                                                                                                                           Education, health/Births, deaths
    ## 171                                                                                                                           Education, health/Births, deaths
    ## 172                                                                                                                           Education, health/Births, deaths
    ## 173                                                                                                                           Education, health/Births, deaths
    ## 174                                                                                                                           Education, health/Births, deaths
    ## 175                                                                                                                           Education, health/Births, deaths
    ## 176                                                                                                                           Education, health/Births, deaths
    ## 177                                                                                                                           Education, health/Births, deaths
    ## 178                                                                                                                           Education, health/Births, deaths
    ## 179                                                                                                                           Education, health/Births, deaths
    ## 180                                                                                                                           Education, health/Births, deaths
    ## 181                                                                                                                           Education, health/Births, deaths
    ## 182                                                                                                                           Education, health/Births, deaths
    ## 183                                                                                                                           Education, health/Births, deaths
    ## 184                                                                                                                           Education, health/Births, deaths
    ## 185                                                                                                                           Education, health/Births, deaths
    ## 186                                                                                                                           Education, health/Births, deaths
    ## 187                                                                                                                           Education, health/Births, deaths
    ## 188                                                                                                                           Education, health/Births, deaths
    ## 189                                                                                                                           Education, health/Births, deaths
    ## 190                                                                                                                           Education, health/Births, deaths
    ## 191                                                                                                                           Education, health/Births, deaths
    ## 192                                                                                                                           Education, health/Births, deaths
    ## 193                                                                                                                           Education, health/Births, deaths
    ## 194                                                                                                                           Education, health/Births, deaths
    ## 195                                                                                                                           Education, health/Births, deaths
    ## 196                                                                                                                           Education, health/Births, deaths
    ## 197                                                                                                                           Education, health/Births, deaths
    ## 198                                                                                                                                  Education, health/Disease
    ## 199                                                                                                                                  Education, health/Disease
    ## 200                                                                                                                                  Education, health/Disease
    ## 201                                                                                                                                  Education, health/Disease
    ## 202                                                                                                                                  Education, health/Disease
    ## 203                                                                                                                                  Education, health/Disease
    ## 204                                                                                                              Education, health/General educational schools
    ## 205                                                                                                              Education, health/General educational schools
    ## 206                                                                                                              Education, health/General educational schools
    ## 207                                                                                                              Education, health/General educational schools
    ## 208                                                                                                              Education, health/General educational schools
    ## 209                                                                                                              Education, health/General educational schools
    ## 210                                                                                                              Education, health/General educational schools
    ## 211                                                                                                              Education, health/General educational schools
    ## 212                                                                                                              Education, health/General educational schools
    ## 213                                                                                                              Education, health/General educational schools
    ## 214                                                                                                              Education, health/General educational schools
    ## 215                                                                                                              Education, health/General educational schools
    ## 216                                                                                                              Education, health/General educational schools
    ## 217                                                                                                              Education, health/General educational schools
    ## 218                                                                                                              Education, health/General educational schools
    ## 219                                                                                                              Education, health/General educational schools
    ## 220                                                                                                              Education, health/General educational schools
    ## 221                                                                                                              Education, health/General educational schools
    ## 222                                                                                                              Education, health/General educational schools
    ## 223                                                                                                         Education, health/General indicators for Education
    ## 224                                                                                                         Education, health/General indicators for Education
    ## 225                                                                                                         Education, health/General indicators for Education
    ## 226                                                                                                         Education, health/General indicators for Education
    ## 227                                                                                                         Education, health/General indicators for Education
    ## 228                                                                                                         Education, health/General indicators for Education
    ## 229                                                                                                                         Education, health/Health insurance
    ## 230                                                                                                                         Education, health/Health insurance
    ## 231                                                                                                                         Education, health/Health insurance
    ## 232                                                                                                                         Education, health/Health insurance
    ## 233                                                                                                                         Education, health/Health insurance
    ## 234                                                                                                        Education, health/Main indicators for Health sector
    ## 235                                                                                                        Education, health/Main indicators for Health sector
    ## 236                                                                                                        Education, health/Main indicators for Health sector
    ## 237                                                                                                        Education, health/Main indicators for Health sector
    ## 238                                                                                                        Education, health/Main indicators for Health sector
    ## 239                                                                                                        Education, health/Main indicators for Health sector
    ## 240                                                                                                        Education, health/Main indicators for Health sector
    ## 241                                                                                                        Education, health/Main indicators for Health sector
    ## 242                                                                                                        Education, health/Main indicators for Health sector
    ## 243                                                                                                        Education, health/Main indicators for Health sector
    ## 244                                                                                                        Education, health/Main indicators for Health sector
    ## 245                                                                                                        Education, health/Main indicators for Health sector
    ## 246                                                                                                        Education, health/Main indicators for Health sector
    ## 247                                                                                                        Education, health/Main indicators for Health sector
    ## 248                                                                                                        Education, health/Main indicators for Health sector
    ## 249                                                                                                        Education, health/Main indicators for Health sector
    ## 250                                                                                                        Education, health/Main indicators for Health sector
    ## 251                                                                                                        Education, health/Main indicators for Health sector
    ## 252                                                                                                                     Education, health/Pre-school education
    ## 253                                                                                                                     Education, health/Pre-school education
    ## 254                                                                                                                     Education, health/Pre-school education
    ## 255                                                                                                                     Education, health/Pre-school education
    ## 256                                                                                                                     Education, health/Pre-school education
    ## 257                                                                                                                     Education, health/Pre-school education
    ## 258                                                                                                                     Education, health/Pre-school education
    ## 259                                                                                                                     Education, health/Pre-school education
    ## 260                                                                                                                     Education, health/Pre-school education
    ## 261                                                                                                                     Education, health/Pre-school education
    ## 262                                                                                                    Education, health/Universities, institutes and colleges
    ## 263                                                                                                    Education, health/Universities, institutes and colleges
    ## 264                                                                                                    Education, health/Universities, institutes and colleges
    ## 265                                                                                                    Education, health/Universities, institutes and colleges
    ## 266                                                                                                    Education, health/Universities, institutes and colleges
    ## 267                                                                                                    Education, health/Universities, institutes and colleges
    ## 268                                                                                                    Education, health/Universities, institutes and colleges
    ## 269                                                                                                    Education, health/Universities, institutes and colleges
    ## 270                                                                                                                     Education, health/Vocational education
    ## 271                                                                                                                     Education, health/Vocational education
    ## 272                                                                                                                     Education, health/Vocational education
    ## 273                                                                                                                     Education, health/Vocational education
    ## 274                                                                                                                     Education, health/Vocational education
    ## 275                                                                                                                     Education, health/Vocational education
    ## 276                                                                                                                     Education, health/Vocational education
    ## 277                                                                                                                     Education, health/Vocational education
    ## 278                                                                                             Historical data/Administrative territorial division of the MPR
    ## 279                                                                                             Historical data/Administrative territorial division of the MPR
    ## 280                                                                                                                                Historical data/Agriculture
    ## 281                                                                                                                                Historical data/Agriculture
    ## 282                                                                                                                                Historical data/Agriculture
    ## 283                                                                                                                                Historical data/Agriculture
    ## 284                                                                                                                                Historical data/Agriculture
    ## 285                                                                                                                                Historical data/Agriculture
    ## 286                                                                                                                                Historical data/Agriculture
    ## 287                                                                                                                                Historical data/Agriculture
    ## 288                                                                                                                                Historical data/Agriculture
    ## 289                                                                                                                                Historical data/Agriculture
    ## 290                                                                                                                                Historical data/Agriculture
    ## 291                                                                                                                                Historical data/Agriculture
    ## 292                                                                                                                                Historical data/Agriculture
    ## 293                                                                                                                                Historical data/Agriculture
    ## 294                                                                                                                                Historical data/Agriculture
    ## 295                                                                                                                                Historical data/Agriculture
    ## 296                                                                                                                                Historical data/Agriculture
    ## 297                                                                                                                                Historical data/Agriculture
    ## 298                                                                                                                                Historical data/Agriculture
    ## 299                                                                                                             Historical data/Education, culture and science
    ## 300                                                                                                             Historical data/Education, culture and science
    ## 301                                                                                                             Historical data/Education, culture and science
    ## 302                                                                                                             Historical data/Education, culture and science
    ## 303                                                                                                             Historical data/Education, culture and science
    ## 304                                                                                                             Historical data/Education, culture and science
    ## 305                                                                                                             Historical data/Education, culture and science
    ## 306                                                                                                             Historical data/Education, culture and science
    ## 307                                                                                                             Historical data/Education, culture and science
    ## 308                                                                                                             Historical data/Education, culture and science
    ## 309                                                                                                             Historical data/Education, culture and science
    ## 310                                                                                                             Historical data/Education, culture and science
    ## 311                                                                                                             Historical data/Education, culture and science
    ## 312                                                                                                                                 Historical data/Enterprise
    ## 313                                                                                                                                 Historical data/Enterprise
    ## 314                                                                                                                                 Historical data/Enterprise
    ## 315                                                                                                                                 Historical data/Enterprise
    ## 316                                                                                                                                 Historical data/Enterprise
    ## 317                                                                                                                                 Historical data/Enterprise
    ## 318                                                                                                                                 Historical data/Enterprise
    ## 319                                                                                                                          Historical data/Health protection
    ## 320                                                                                                                          Historical data/Health protection
    ## 321                                                                                                                          Historical data/Health protection
    ## 322                                                                                                                          Historical data/Health protection
    ## 323                                                                                                                       Historical data/Integrated_Indicator
    ## 324                                                                                                                       Historical data/Integrated_Indicator
    ## 325                                                                                                                       Historical data/Integrated_Indicator
    ## 326                                                                                                                       Historical data/Integrated_Indicator
    ## 327                                                                                                                       Historical data/Integrated_Indicator
    ## 328                                                                                                                       Historical data/Integrated_Indicator
    ## 329                                                                                                                       Historical data/Integrated_Indicator
    ## 330                                                                                                                       Historical data/Integrated_Indicator
    ## 331                                                                                                                Historical data/Investment and construction
    ## 332                                                                                                                Historical data/Investment and construction
    ## 333                                                                                                                Historical data/Investment and construction
    ## 334                                                                                                                Historical data/Investment and construction
    ## 335                                                                                                                Historical data/Investment and construction
    ## 336                                                                                                                Historical data/Investment and construction
    ## 337                                                                                                                Historical data/Investment and construction
    ## 338                                                                                                                        Historical data/Number of employees
    ## 339                                                                                                                        Historical data/Number of employees
    ## 340                                                                                                                        Historical data/Number of employees
    ## 341                                                                                                                        Historical data/Number of employees
    ## 342                                                                                                                                 Historical data/Population
    ## 343                                                                                                                                 Historical data/Population
    ## 344                                                                                                                                 Historical data/Population
    ## 345                                                                                                                                 Historical data/Population
    ## 346                                                                                                                                 Historical data/Population
    ## 347                                                                                                                                 Historical data/Population
    ## 348                                                                                                                                 Historical data/Population
    ## 349                                                                                                                                 Historical data/Population
    ## 350                                                                                                                                 Historical data/Population
    ## 351                                                                                                                                 Historical data/Population
    ## 352                                                                                                                                 Historical data/Population
    ## 353                                                                                                            Historical data/Progress of people's activities
    ## 354                                                                                                            Historical data/Progress of people's activities
    ## 355                                                                                                            Historical data/Progress of people's activities
    ## 356                                                                                                            Historical data/Progress of people's activities
    ## 357                                                                                                            Historical data/Progress of people's activities
    ## 358                                                                                                            Historical data/Progress of people's activities
    ## 359                                                                                                                               Historical data/State budget
    ## 360                                                                                                                               Historical data/State budget
    ## 361                                                                                                                                      Historical data/Trade
    ## 362                                                                                                                                      Historical data/Trade
    ## 363                                                                                                                                      Historical data/Trade
    ## 364                                                                                                                                      Historical data/Trade
    ## 365                                                                                                                                      Historical data/Trade
    ## 366                                                                                                                                      Historical data/Trade
    ## 367                                                                                                                                      Historical data/Trade
    ## 368                                                                                                                                      Historical data/Trade
    ## 369                                                                                                                                      Historical data/Trade
    ## 370                                                                                                                                      Historical data/Trade
    ## 371                                                                                                                Historical data/Transport and communication
    ## 372                                                                                                                Historical data/Transport and communication
    ## 373                                                                                                                Historical data/Transport and communication
    ## 374                                                                                                                Historical data/Transport and communication
    ## 375                                                                                                                Historical data/Transport and communication
    ## 376                                                                                                                Historical data/Transport and communication
    ## 377                                                                                                                Historical data/Transport and communication
    ## 378                                                                                                                Historical data/Transport and communication
    ## 379                                                                                                                     Historical data/Utilities and services
    ## 380                                                                                                                     Historical data/Utilities and services
    ## 381                                                                                                                     Historical data/Utilities and services
    ## 382                                                                                                                              Industry, service/Agriculture
    ## 383                                                                                                                              Industry, service/Agriculture
    ## 384                                                                                                                              Industry, service/Agriculture
    ## 385                                                                                                                              Industry, service/Agriculture
    ## 386                                                                                                                              Industry, service/Agriculture
    ## 387                                                                                                                              Industry, service/Agriculture
    ## 388                                                                                                                              Industry, service/Agriculture
    ## 389                                                                                                                              Industry, service/Agriculture
    ## 390                                                                                                                              Industry, service/Agriculture
    ## 391                                                                                                                              Industry, service/Agriculture
    ## 392                                                                                                                              Industry, service/Agriculture
    ## 393                                                                                                                              Industry, service/Agriculture
    ## 394                                                                                                                              Industry, service/Agriculture
    ## 395                                                                                                                              Industry, service/Agriculture
    ## 396                                                                                                                              Industry, service/Agriculture
    ## 397                                                                                                                              Industry, service/Agriculture
    ## 398                                                                                                                              Industry, service/Agriculture
    ## 399                                                                                                                              Industry, service/Agriculture
    ## 400                                                                                                                              Industry, service/Agriculture
    ## 401                                                                                                                              Industry, service/Agriculture
    ## 402                                                                                                                              Industry, service/Agriculture
    ## 403                                                                                                                             Industry, service/Construction
    ## 404                                                                                                                             Industry, service/Construction
    ## 405                                                                                                                             Industry, service/Construction
    ## 406                                                                                                                             Industry, service/Construction
    ## 407                                                                                                                             Industry, service/Construction
    ## 408                                                                                                                             Industry, service/Construction
    ## 409                                                                                                                             Industry, service/Construction
    ## 410                                                                                                      Industry, service/Culture, cultural creative industry
    ## 411                                                                                                      Industry, service/Culture, cultural creative industry
    ## 412                                                                                                      Industry, service/Culture, cultural creative industry
    ## 413                                                                                                      Industry, service/Culture, cultural creative industry
    ## 414                                                                                                      Industry, service/Culture, cultural creative industry
    ## 415                                                                                                      Industry, service/Culture, cultural creative industry
    ## 416                                                                                                      Industry, service/Culture, cultural creative industry
    ## 417                                                                                                      Industry, service/Culture, cultural creative industry
    ## 418                                                                                                      Industry, service/Culture, cultural creative industry
    ## 419                                                                                                      Industry, service/Culture, cultural creative industry
    ## 420                                                                                                                                 Industry, service/Industry
    ## 421                                                                                                                                 Industry, service/Industry
    ## 422                                                                                                                                 Industry, service/Industry
    ## 423                                                                                                                                 Industry, service/Industry
    ## 424                                                                                                                                 Industry, service/Industry
    ## 425                                                                                                                                 Industry, service/Industry
    ## 426                                                                                                                                 Industry, service/Industry
    ## 427                                                                                                                                 Industry, service/Industry
    ## 428                                                                                                                                 Industry, service/Industry
    ## 429                                                                                                                                 Industry, service/Industry
    ## 430                                                                                                                                 Industry, service/Industry
    ## 431                                                                                                                                 Industry, service/Industry
    ## 432                                                                                                                                 Industry, service/Industry
    ## 433                                                                                                                                 Industry, service/Industry
    ## 434                                                                                                                                 Industry, service/Industry
    ## 435                                                                                                                                 Industry, service/Industry
    ## 436                                                                                                                                 Industry, service/Industry
    ## 437                                                                                                                                Industry, service/Livestock
    ## 438                                                                                                                                Industry, service/Livestock
    ## 439                                                                                                                                Industry, service/Livestock
    ## 440                                                                                                                                Industry, service/Livestock
    ## 441                                                                                                                                Industry, service/Livestock
    ## 442                                                                                                                                Industry, service/Livestock
    ## 443                                                                                                                                Industry, service/Livestock
    ## 444                                                                                                                                Industry, service/Livestock
    ## 445                                                                                                                                Industry, service/Livestock
    ## 446                                                                                                                                Industry, service/Livestock
    ## 447                                                                                                                                Industry, service/Livestock
    ## 448                                                                                                                                Industry, service/Livestock
    ## 449                                                                                                                                Industry, service/Livestock
    ## 450                                                                                                                                Industry, service/Livestock
    ## 451                                                                                                                                Industry, service/Livestock
    ## 452                                                                                                                                Industry, service/Livestock
    ## 453                                                                                                                                Industry, service/Livestock
    ## 454                                                                                                                                Industry, service/Livestock
    ## 455                                                                                                                                Industry, service/Livestock
    ## 456                                                                                                                                  Industry, service/Science
    ## 457                                                                                                                                  Industry, service/Science
    ## 458                                                                                                                                  Industry, service/Tourism
    ## 459                                                                                                                                  Industry, service/Tourism
    ## 460                                                                                                                                  Industry, service/Tourism
    ## 461                                                                                                                                  Industry, service/Tourism
    ## 462                                                                                                                                  Industry, service/Tourism
    ## 463                                                                                                                                  Industry, service/Tourism
    ## 464                                                                                                                                  Industry, service/Tourism
    ## 465                                                                                                                                  Industry, service/Tourism
    ## 466                                                                                                                                  Industry, service/Tourism
    ## 467                                                                                                              Industry, service/Trade, hotel and restaurant
    ## 468                                                                                                              Industry, service/Trade, hotel and restaurant
    ## 469                                                                                                              Industry, service/Trade, hotel and restaurant
    ## 470                                                                                                                           Industry, service/Transportation
    ## 471                                                                                                                           Industry, service/Transportation
    ## 472                                                                                                                           Industry, service/Transportation
    ## 473                                                                                                                           Industry, service/Transportation
    ## 474                                                                                                                           Industry, service/Transportation
    ## 475                                                                                                                           Industry, service/Transportation
    ## 476                                                                                                                            Labour, business/Civil servants
    ## 477                                                                                                                            Labour, business/Civil servants
    ## 478                                                                                                                            Labour, business/Civil servants
    ## 479                                                                                                                            Labour, business/Civil servants
    ## 480                                                                                                                            Labour, business/Civil servants
    ## 481                                                                                                                            Labour, business/Civil servants
    ## 482                                                                                                                               Labour, business/Decent work
    ## 483                                                                                                                               Labour, business/Decent work
    ## 484                                                                                                                               Labour, business/Decent work
    ## 485                                                                                                                               Labour, business/Decent work
    ## 486                                                                                                                               Labour, business/Decent work
    ## 487                                                                                                                               Labour, business/Decent work
    ## 488                                                                                                                               Labour, business/Decent work
    ## 489                                                                                                                               Labour, business/Decent work
    ## 490                                                                                                                               Labour, business/Decent work
    ## 491                                                                                                                               Labour, business/Decent work
    ## 492                                                                                                                               Labour, business/Decent work
    ## 493                                                                                                                               Labour, business/Decent work
    ## 494                                                                                                                               Labour, business/Decent work
    ## 495                                                                                                                               Labour, business/Decent work
    ## 496                                                                                                                               Labour, business/Decent work
    ## 497                                                                                                                               Labour, business/Decent work
    ## 498                                                                                                                               Labour, business/Decent work
    ## 499                                                                                                                               Labour, business/Decent work
    ## 500                                                                                                                               Labour, business/Decent work
    ## 501                                                                                                                               Labour, business/Decent work
    ## 502                                                                                                                               Labour, business/Decent work
    ## 503                                                                                                                               Labour, business/Decent work
    ## 504                                                                                                                               Labour, business/Decent work
    ## 505                                                                                                                                    Labour, business/Labour
    ## 506                                                                                                                                    Labour, business/Labour
    ## 507                                                                                                                                    Labour, business/Labour
    ## 508                                                                                                                                    Labour, business/Labour
    ## 509                                                                                                                                    Labour, business/Labour
    ## 510                                                                                                                                    Labour, business/Labour
    ## 511                                                                                                                                    Labour, business/Labour
    ## 512                                                                                                                                    Labour, business/Labour
    ## 513                                                                                                                                    Labour, business/Labour
    ## 514                                                                                                                                    Labour, business/Labour
    ## 515                                                                                                                                    Labour, business/Labour
    ## 516                                                                                                                                    Labour, business/Labour
    ## 517                                                                                                                                    Labour, business/Labour
    ## 518                                                                                                                                    Labour, business/Labour
    ## 519                                                                                                                                      Labour, business/SMEs
    ## 520                                                                                                                                      Labour, business/SMEs
    ## 521                                                                                                                                      Labour, business/SMEs
    ## 522                                                                                                                                      Labour, business/SMEs
    ## 523                                                                                                                                      Labour, business/SMEs
    ## 524                                                                                                                                      Labour, business/SMEs
    ## 525                                                                                                             Labour, business/Statistical Business Register
    ## 526                                                                                                             Labour, business/Statistical Business Register
    ## 527                                                                                                             Labour, business/Statistical Business Register
    ## 528                                                                                                             Labour, business/Statistical Business Register
    ## 529                                                                                                             Labour, business/Statistical Business Register
    ## 530                                                                                                             Labour, business/Statistical Business Register
    ## 531                                                                                                             Labour, business/Statistical Business Register
    ## 532                                                                                                             Labour, business/Statistical Business Register
    ## 533                                                                                                             Labour, business/Statistical Business Register
    ## 534                                                                                                             Labour, business/Statistical Business Register
    ## 535                                                                                                             Labour, business/Statistical Business Register
    ## 536                                                                                                             Labour, business/Statistical Business Register
    ## 537                                                                                                             Labour, business/Statistical Business Register
    ## 538                                                                                                             Labour, business/Statistical Business Register
    ## 539                                                                                                             Labour, business/Statistical Business Register
    ## 540                                                                                                             Labour, business/Statistical Business Register
    ## 541                                                                                                             Labour, business/Statistical Business Register
    ## 542                                                                                                             Labour, business/Statistical Business Register
    ## 543                                                                                                             Labour, business/Statistical Business Register
    ## 544                                                                                                             Labour, business/Statistical Business Register
    ## 545                                                                                                             Labour, business/Statistical Business Register
    ## 546                                                                                                             Labour, business/Statistical Business Register
    ## 547                                                                                                             Labour, business/Statistical Business Register
    ## 548                                                                                                             Labour, business/Statistical Business Register
    ## 549                                                                                                             Labour, business/Statistical Business Register
    ## 550                                                                                                             Labour, business/Statistical Business Register
    ## 551                                                                                                             Labour, business/Statistical Business Register
    ## 552                                                                                                              Population, household/1_Population, household
    ## 553                                                                                                              Population, household/1_Population, household
    ## 554                                                                                                              Population, household/1_Population, household
    ## 555                                                                                                              Population, household/1_Population, household
    ## 556                                                                                                              Population, household/1_Population, household
    ## 557                                                                                                              Population, household/1_Population, household
    ## 558                                                                                                              Population, household/1_Population, household
    ## 559                                                                                                              Population, household/1_Population, household
    ## 560                                                                                                              Population, household/1_Population, household
    ## 561                                                                                                              Population, household/1_Population, household
    ## 562                                                                                                              Population, household/1_Population, household
    ## 563                                                                                                              Population, household/1_Population, household
    ## 564                                                                                                              Population, household/1_Population, household
    ## 565                                                                                                              Population, household/1_Population, household
    ## 566                                                                                                              Population, household/1_Population, household
    ## 567                                                                                                              Population, household/1_Population, household
    ## 568                                                                                                              Population, household/1_Population, household
    ## 569                                                                                                              Population, household/1_Population, household
    ## 570                                                                                                              Population, household/1_Population, household
    ## 571                                                                                                              Population, household/1_Population, household
    ## 572                                                                                                              Population, household/1_Population, household
    ## 573                                                                                                              Population, household/1_Population, household
    ## 574                                                                                                              Population, household/1_Population, household
    ## 575                                                                                                              Population, household/1_Population, household
    ## 576                                                                                                              Population, household/1_Population, household
    ## 577                                                                                                              Population, household/1_Population, household
    ## 578                                                                                                              Population, household/1_Population, household
    ## 579                                                                                                     Population, household/2_Regular movement of population
    ## 580                                                                                                     Population, household/2_Regular movement of population
    ## 581                                                                                                     Population, household/2_Regular movement of population
    ## 582                                                                                                     Population, household/2_Regular movement of population
    ## 583                                                                                                     Population, household/2_Regular movement of population
    ## 584                                                                                                     Population, household/2_Regular movement of population
    ## 585                                                                                                     Population, household/2_Regular movement of population
    ## 586                                                                                                     Population, household/2_Regular movement of population
    ## 587                                                                                                     Population, household/2_Regular movement of population
    ## 588                                                                                                     Population, household/2_Regular movement of population
    ## 589                                                                                                     Population, household/2_Regular movement of population
    ## 590                                                                                                     Population, household/2_Regular movement of population
    ## 591                                                                                                     Population, household/2_Regular movement of population
    ## 592                                                                                                     Population, household/2_Regular movement of population
    ## 593                                                                                                     Population, household/2_Regular movement of population
    ## 594                                                                                                     Population, household/2_Regular movement of population
    ## 595                                                                                                     Population, household/2_Regular movement of population
    ## 596                                                                                                     Population, household/2_Regular movement of population
    ## 597                                                                                                     Population, household/2_Regular movement of population
    ## 598                                                                                                     Population, household/2_Regular movement of population
    ## 599                                                                                                     Population, household/2_Regular movement of population
    ## 600                                                                                                     Population, household/2_Regular movement of population
    ## 601                                                                                                     Population, household/2_Regular movement of population
    ## 602                                                                                                     Population, household/2_Regular movement of population
    ## 603                                                                                                     Population, household/2_Regular movement of population
    ## 604                                                                                                     Population, household/2_Regular movement of population
    ## 605                                                                                                     Population, household/2_Regular movement of population
    ## 606                                                                                                     Population, household/2_Regular movement of population
    ## 607                                                                                                     Population, household/2_Regular movement of population
    ## 608                                                                                                     Population, household/2_Regular movement of population
    ## 609                                                                                                     Population, household/2_Regular movement of population
    ## 610                                                                                                     Population, household/2_Regular movement of population
    ## 611                                                                                                     Population, household/2_Regular movement of population
    ## 612                                                                                                     Population, household/2_Regular movement of population
    ## 613                                                                                                     Population, household/2_Regular movement of population
    ## 614                                                                                                     Population, household/2_Regular movement of population
    ## 615                                                                                                     Population, household/2_Regular movement of population
    ## 616                                                                                                     Population, household/2_Regular movement of population
    ## 617                                                                                                     Population, household/2_Regular movement of population
    ## 618                                                                                                     Population, household/2_Regular movement of population
    ## 619                                                                                                                           Population, household/3_Herdsmen
    ## 620                                                                                                                           Population, household/3_Herdsmen
    ## 621                                                                                                                           Population, household/3_Herdsmen
    ## 622                                                                                                                           Population, household/3_Herdsmen
    ## 623                                                                                                                           Population, household/3_Herdsmen
    ## 624                                                                                                                           Population, household/3_Herdsmen
    ## 625                                                                                                            Population, household/3_Infrastructure, housing
    ## 626                                                                                                            Population, household/3_Infrastructure, housing
    ## 627                                                                                                            Population, household/3_Infrastructure, housing
    ## 628                                                                                                            Population, household/3_Infrastructure, housing
    ## 629                                                                                                            Population, household/3_Infrastructure, housing
    ## 630                                                                                                            Population, household/3_Infrastructure, housing
    ## 631                                                                                                            Population, household/3_Infrastructure, housing
    ## 632                                                                                                            Population, household/3_Infrastructure, housing
    ## 633                                                                                                            Population, household/3_Infrastructure, housing
    ## 634                                                                                                              Population, household/4_Population projection
    ## 635                                                                                                              Population, household/4_Population projection
    ## 636                                                                                                              Population, household/4_Population projection
    ## 637                                                                                                     Population, household/5_Adminstrative units, territory
    ## 638                                                                                                     Population, household/5_Adminstrative units, territory
    ## 639                                                                                                     Population, household/5_Adminstrative units, territory
    ## 640                                                                                                     Population, household/5_Adminstrative units, territory
    ## 641                                                                                                                           Regional development/Agriculture
    ## 642                                                                                                                           Regional development/Agriculture
    ## 643                                                                                                                           Regional development/Agriculture
    ## 644                                                                                                                           Regional development/Agriculture
    ## 645                                                                                                                          Regional development/Construction
    ## 646                                                                                                                          Regional development/Construction
    ## 647                                                                                                                          Regional development/Construction
    ## 648                                                                                                                          Regional development/Construction
    ## 649                                                                                                                            Regional development/Disability
    ## 650                                                                                                                            Regional development/Disability
    ## 651                                                                                                                            Regional development/Disability
    ## 652                                                                                                                            Regional development/Disability
    ## 653                                                                                                                            Regional development/Disability
    ## 654                                                                                                                            Regional development/Disability
    ## 655                                                                                                                            Regional development/Disability
    ## 656                                                                                                                            Regional development/Disability
    ## 657                                                                                         Regional development/Education, Science, and Intellectual Property
    ## 658                                                                                         Regional development/Education, Science, and Intellectual Property
    ## 659                                                                                         Regional development/Education, Science, and Intellectual Property
    ## 660                                                                                         Regional development/Education, Science, and Intellectual Property
    ## 661                                                                                         Regional development/Education, Science, and Intellectual Property
    ## 662                                                                                         Regional development/Education, Science, and Intellectual Property
    ## 663                                                                                         Regional development/Education, Science, and Intellectual Property
    ## 664                                                                                         Regional development/Education, Science, and Intellectual Property
    ## 665                                                                                         Regional development/Education, Science, and Intellectual Property
    ## 666                                                                                         Regional development/Education, Science, and Intellectual Property
    ## 667                                                                                         Regional development/Education, Science, and Intellectual Property
    ## 668                                                                                         Regional development/Education, Science, and Intellectual Property
    ## 669                                                                                         Regional development/Education, Science, and Intellectual Property
    ## 670                                                                                         Regional development/Education, Science, and Intellectual Property
    ## 671                                                                                         Regional development/Education, Science, and Intellectual Property
    ## 672                                                                                         Regional development/Education, Science, and Intellectual Property
    ## 673                                                                                         Regional development/Education, Science, and Intellectual Property
    ## 674                                                                                         Regional development/Education, Science, and Intellectual Property
    ## 675                                                                                         Regional development/Education, Science, and Intellectual Property
    ## 676                                                                                         Regional development/Education, Science, and Intellectual Property
    ## 677                                                                                         Regional development/Education, Science, and Intellectual Property
    ## 678                                                                                         Regional development/Education, Science, and Intellectual Property
    ## 679                                                                                         Regional development/Education, Science, and Intellectual Property
    ## 680                                                                                         Regional development/Education, Science, and Intellectual Property
    ## 681                                                                                         Regional development/Education, Science, and Intellectual Property
    ## 682                                                                                                                              Regional development/Election
    ## 683                                                                                                                              Regional development/Election
    ## 684                                                                                                                              Regional development/Election
    ## 685                                                                                                                              Regional development/Election
    ## 686                                                                                                                     Regional development/Government budget
    ## 687                                                                                                                     Regional development/Government budget
    ## 688                                                                                                                     Regional development/Government budget
    ## 689                                                                                                                     Regional development/Human development
    ## 690                                                                                                                     Regional development/Human development
    ## 691                                                                                                                     Regional development/Human development
    ## 692                                                                                                                     Regional development/Human development
    ## 693                                                                                                                     Regional development/Human development
    ## 694                                                                                                               Regional development/Infrastructure, housing
    ## 695                                                                                                               Regional development/Infrastructure, housing
    ## 696                                                                                                               Regional development/Infrastructure, housing
    ## 697                                                                                                               Regional development/Infrastructure, housing
    ## 698                                                                                                               Regional development/Infrastructure, housing
    ## 699                                                                                                               Regional development/Infrastructure, housing
    ## 700                                                                                                                     Regional development/Justice and crime
    ## 701                                                                                                                     Regional development/Justice and crime
    ## 702                                                                                                                     Regional development/Justice and crime
    ## 703                                                                                                                     Regional development/Justice and crime
    ## 704                                                                                                                     Regional development/Justice and crime
    ## 705                                                                                                                     Regional development/Justice and crime
    ## 706                                                                                                                     Regional development/Justice and crime
    ## 707                                                                                                                     Regional development/Justice and crime
    ## 708                                                                                                                     Regional development/Justice and crime
    ## 709                                                                                                                     Regional development/Justice and crime
    ## 710                                                                                                                     Regional development/Justice and crime
    ## 711                                                                                                                     Regional development/Justice and crime
    ## 712                                                                                                                     Regional development/Justice and crime
    ## 713                                                                                                                     Regional development/Justice and crime
    ## 714                                                                                                                     Regional development/Justice and crime
    ## 715                                                                                                                     Regional development/Justice and crime
    ## 716                                                                                                                     Regional development/Justice and crime
    ## 717                                                                                                                     Regional development/Justice and crime
    ## 718                                                                                                                     Regional development/Justice and crime
    ## 719                                                                                                                     Regional development/Justice and crime
    ## 720                                                                                                                     Regional development/Justice and crime
    ## 721                                                                                                                     Regional development/Justice and crime
    ## 722                                                                                                                     Regional development/Justice and crime
    ## 723                                                                                                                     Regional development/Justice and crime
    ## 724                                                                                                                             Regional development/Livestock
    ## 725                                                                                                                             Regional development/Livestock
    ## 726                                                                                                                             Regional development/Livestock
    ## 727                                                                                                                             Regional development/Livestock
    ## 728                                                                                                                             Regional development/Livestock
    ## 729                                                                                                                             Regional development/Livestock
    ## 730                                                                                                                             Regional development/Livestock
    ## 731                                                                                                                             Regional development/Livestock
    ## 732                                                                                                                             Regional development/Livestock
    ## 733                                                                                                                             Regional development/Livestock
    ## 734                                                                                                                             Regional development/Livestock
    ## 735                                                                                                                             Regional development/Livestock
    ## 736                                                                                                     Regional development/Monasteries, Temples and Churches
    ## 737                                                                                                     Regional development/Monasteries, Temples and Churches
    ## 738                                                                                                     Regional development/Monasteries, Temples and Churches
    ## 739                                                                                                                     Regional development/Money and Finance
    ## 740                                                                                                                     Regional development/Money and Finance
    ## 741                                                                                                                     Regional development/Money and Finance
    ## 742                                                                                                                     Regional development/National accounts
    ## 743                                                                                                                     Regional development/National accounts
    ## 744                                                                                                                     Regional development/National accounts
    ## 745                                                                                                                     Regional development/National accounts
    ## 746                                                                                                                     Regional development/National accounts
    ## 747                                                                                                                     Regional development/National accounts
    ## 748                                                                                                                     Regional development/National accounts
    ## 749                                                                                                              Regional development/Population and household
    ## 750                                                                                                              Regional development/Population and household
    ## 751                                                                                                              Regional development/Population and household
    ## 752                                                                                                              Regional development/Population and household
    ## 753                                                                                                              Regional development/Population and household
    ## 754                                                                                                              Regional development/Population and household
    ## 755                                                                                                              Regional development/Population and household
    ## 756                                                                                                              Regional development/Population and household
    ## 757                                                                                                              Regional development/Population and household
    ## 758                                                                                                              Regional development/Population and household
    ## 759                                                                                                              Regional development/Population and household
    ## 760                                                                                                              Regional development/Population and household
    ## 761                                                                                                              Regional development/Population and household
    ## 762                                                                                                              Regional development/Population and household
    ## 763                                                                                                              Regional development/Population and household
    ## 764                                                                                                              Regional development/Population and household
    ## 765                                                                                                              Regional development/Population and household
    ## 766                                                                                                              Regional development/Population and household
    ## 767                                                                                                              Regional development/Population and household
    ## 768                                                                                                              Regional development/Population and household
    ## 769                                                                                                              Regional development/Population and household
    ## 770                                                                                                              Regional development/Population and household
    ## 771                                                                                                              Regional development/Population and household
    ## 772                                                                                                              Regional development/Population and household
    ## 773                                                                                                                 Regional development/Population livelihood
    ## 774                                                                                                                 Regional development/Population livelihood
    ## 775                                                                                                                 Regional development/Population livelihood
    ## 776                                                                                                                 Regional development/Population livelihood
    ## 777                                                                                                                 Regional development/Population livelihood
    ## 778                                                                                                                                 Regional development/Price
    ## 779                                                                                                                                 Regional development/Price
    ## 780                                                                                                                                 Regional development/Price
    ## 781                                                                                                                                 Regional development/Price
    ## 782                                                                                                                                 Regional development/Price
    ## 783                                                                                                                                 Regional development/Price
    ## 784                                                                                                                                 Regional development/Price
    ## 785                                                                                                                                 Regional development/Price
    ## 786                                                                                                                                 Regional development/Price
    ## 787                                                                                                                                  Regional development/SMEs
    ## 788                                                                                                                                  Regional development/SMEs
    ## 789                                                                                                         Regional development/Statistical business register
    ## 790                                                                                                         Regional development/Statistical business register
    ## 791                                                                                                         Regional development/Statistical business register
    ## 792                                                                                                         Regional development/Statistical business register
    ## 793                                                                                                         Regional development/Statistical business register
    ## 794                                                                                                         Regional development/Statistical business register
    ## 795                                                                                                         Regional development/Statistical business register
    ## 796                                                                                                       Regional development/Territory, administrative units
    ## 797                                                                                                                                 Regional development/Trade
    ## 798                                                                                                                                 Regional development/Trade
    ## 799                                                                                                                                 Regional development/Trade
    ## 800                                                                                                                                 Regional development/Trade
    ## 801                                                                                                                                 Regional development/Trade
    ## 802                                                                                                                                 Regional development/Trade
    ## 803                                                                                                                        Regional development/Transportation
    ## 804                                                                                                                        Regional development/Transportation
    ## 805                                                                                                                        Regional development/Transportation
    ## 806                                                                                                                        Regional development/Transportation
    ## 807                                                                                                                        Regional development/Transportation
    ## 808                                                                                                                        Regional development/Transportation
    ## 809                                                                                                                        Regional development/Transportation
    ## 810                                                                                                                        Regional development/Transportation
    ## 811                                                                                                                        Regional development/Transportation
    ## 812                                                                                                                        Regional development/Transportation
    ## 813                                                                                                                        Regional development/Transportation
    ## 814                                                                                                                        Regional development/Transportation
    ## 815                                                                                                                        Regional development/Transportation
    ## 816                                                                                                                        Regional development/Transportation
    ## 817                                                                                                                        Regional development/Transportation
    ## 818                                                                                                                            Society, development/Disability
    ## 819                                                                                                                            Society, development/Disability
    ## 820                                                                                                                            Society, development/Disability
    ## 821                                                                                                                            Society, development/Disability
    ## 822                                                                                                                            Society, development/Disability
    ## 823                                                                                                                            Society, development/Disability
    ## 824                                                                                                                            Society, development/Disability
    ## 825                                                                                                                            Society, development/Disability
    ## 826                                                                                                                            Society, development/Disability
    ## 827                                                                                                                              Society, development/Election
    ## 828                                                                                                                              Society, development/Election
    ## 829                                                                                                                              Society, development/Election
    ## 830                                                                                                                              Society, development/Election
    ## 831                                                                                                                              Society, development/Election
    ## 832                                                                                                                         Society, development/Food Security
    ## 833                                                                                                                         Society, development/Food Security
    ## 834                                                                                                                         Society, development/Food Security
    ## 835                                                                                                                         Society, development/Food Security
    ## 836                                                                                                                         Society, development/Food Security
    ## 837                                                                                                                         Society, development/Food Security
    ## 838                                                                                                                         Society, development/Food Security
    ## 839                                                                                                                         Society, development/Food Security
    ## 840                                                                                                                                Society, development/Gender
    ## 841                                                                                                                                Society, development/Gender
    ## 842                                                                                                                                Society, development/Gender
    ## 843                                                                                                                                Society, development/Gender
    ## 844                                                                                                                                Society, development/Gender
    ## 845                                                                                                                                Society, development/Gender
    ## 846                                                                                                                                Society, development/Gender
    ## 847                                                                                                                                Society, development/Gender
    ## 848                                                                                                                                Society, development/Gender
    ## 849                                                                                                                                Society, development/Gender
    ## 850                                                                                                                                Society, development/Gender
    ## 851                                                                                                                                Society, development/Gender
    ## 852                                                                                                                                Society, development/Gender
    ## 853                                                                                                                                Society, development/Gender
    ## 854                                                                                                                                Society, development/Gender
    ## 855                                                                                                                                Society, development/Gender
    ## 856                                                                                                                                Society, development/Gender
    ## 857                                                                                                                                Society, development/Gender
    ## 858                                                                                                                                Society, development/Gender
    ## 859                                                                                                                                Society, development/Gender
    ## 860                                                                                                                                Society, development/Gender
    ## 861                                                                                                                                Society, development/Gender
    ## 862                                                                                                                                Society, development/Gender
    ## 863                                                                                                                                Society, development/Gender
    ## 864                                                                                                                                Society, development/Gender
    ## 865                                                                                                                                Society, development/Gender
    ## 866                                                                                                                                Society, development/Gender
    ## 867                                                                                                      Society, development/Household income and expenditure
    ## 868                                                                                                      Society, development/Household income and expenditure
    ## 869                                                                                                      Society, development/Household income and expenditure
    ## 870                                                                                                      Society, development/Household income and expenditure
    ## 871                                                                                                      Society, development/Household income and expenditure
    ## 872                                                                                                      Society, development/Household income and expenditure
    ## 873                                                                                                      Society, development/Household income and expenditure
    ## 874                                                                                                      Society, development/Household income and expenditure
    ## 875                                                                                                      Society, development/Household income and expenditure
    ## 876                                                                                                      Society, development/Household income and expenditure
    ## 877                                                                                                      Society, development/Household income and expenditure
    ## 878                                                                                                      Society, development/Household income and expenditure
    ## 879                                                                                                      Society, development/Household income and expenditure
    ## 880                                                                                                      Society, development/Household income and expenditure
    ## 881                                                                                                      Society, development/Household income and expenditure
    ## 882                                                                                                      Society, development/Household income and expenditure
    ## 883                                                                                                      Society, development/Household income and expenditure
    ## 884                                                                                                      Society, development/Household income and expenditure
    ## 885                                                                                                      Society, development/Household income and expenditure
    ## 886                                                                                                      Society, development/Household income and expenditure
    ## 887                                                                                                      Society, development/Household income and expenditure
    ## 888                                                                                                               Society, development/Human Development Index
    ## 889                                                                                                               Society, development/Human Development Index
    ## 890                                                                                                               Society, development/Human Development Index
    ## 891                                                                                                               Society, development/Human Development Index
    ## 892                                                                                                               Society, development/Human Development Index
    ## 893                                                                                                               Society, development/Human Development Index
    ## 894                                                                                                               Society, development/Human Development Index
    ## 895                                                                                                                         Society, development/Law and crime
    ## 896                                                                                                                         Society, development/Law and crime
    ## 897                                                                                                                         Society, development/Law and crime
    ## 898                                                                                                                         Society, development/Law and crime
    ## 899                                                                                                                         Society, development/Law and crime
    ## 900                                                                                                                         Society, development/Law and crime
    ## 901                                                                                                                         Society, development/Law and crime
    ## 902                                                                                                                         Society, development/Law and crime
    ## 903                                                                                                                         Society, development/Law and crime
    ## 904                                                                                                                         Society, development/Law and crime
    ## 905                                                                                                                         Society, development/Law and crime
    ## 906                                                                                                                         Society, development/Law and crime
    ## 907                                                                                                                         Society, development/Law and crime
    ## 908                                                                                                                         Society, development/Law and crime
    ## 909                                                                                                                         Society, development/Law and crime
    ## 910                                                                                                                         Society, development/Law and crime
    ## 911                                                                                                                         Society, development/Law and crime
    ## 912                                                                                                                         Society, development/Law and crime
    ## 913                                                                                                                         Society, development/Law and crime
    ## 914                                                                                                                         Society, development/Law and crime
    ## 915                                                                                                                         Society, development/Law and crime
    ## 916                                                                                                                         Society, development/Law and crime
    ## 917                                                                                                                         Society, development/Law and crime
    ## 918                                                                                                                         Society, development/Law and crime
    ## 919                                                                                                                         Society, development/Law and crime
    ## 920                                                                                                                         Society, development/Law and crime
    ## 921                                                                                                                         Society, development/Law and crime
    ## 922                                                                                                                         Society, development/Law and crime
    ## 923                                                                                                                         Society, development/Law and crime
    ## 924                                                                                                                         Society, development/Law and crime
    ## 925                                                                                                                         Society, development/Law and crime
    ## 926                                                                                                                         Society, development/Law and crime
    ## 927                                                                                                                         Society, development/Law and crime
    ## 928                                                                                                                         Society, development/Law and crime
    ## 929                                                                                                                         Society, development/Law and crime
    ## 930                                                                                                                         Society, development/Law and crime
    ## 931                                                                                                                         Society, development/Law and crime
    ## 932                                                                                                                         Society, development/Law and crime
    ## 933                                                                                                                         Society, development/Law and crime
    ## 934                                                                                                                         Society, development/Law and crime
    ## 935                                                                                                                         Society, development/Law and crime
    ## 936                                                                                                                         Society, development/Law and crime
    ## 937                                                                                                                         Society, development/Law and crime
    ## 938                                                                                                                         Society, development/Law and crime
    ## 939                                                                                               Society, development/Millennium Development Goals Indicators
    ## 940                                                                                               Society, development/Millennium Development Goals Indicators
    ## 941                                                                                               Society, development/Millennium Development Goals Indicators
    ## 942                                                                                               Society, development/Millennium Development Goals Indicators
    ## 943                                                                                               Society, development/Millennium Development Goals Indicators
    ## 944                                                                                               Society, development/Millennium Development Goals Indicators
    ## 945                                                                                               Society, development/Millennium Development Goals Indicators
    ## 946                                                                                               Society, development/Millennium Development Goals Indicators
    ## 947                                                                                               Society, development/Millennium Development Goals Indicators
    ## 948                                                                                               Society, development/Millennium Development Goals Indicators
    ## 949                                                                                               Society, development/Millennium Development Goals Indicators
    ## 950                                                                                               Society, development/Millennium Development Goals Indicators
    ## 951                                                                                               Society, development/Millennium Development Goals Indicators
    ## 952                                                                                               Society, development/Millennium Development Goals Indicators
    ## 953                                                                                               Society, development/Millennium Development Goals Indicators
    ## 954                                                                                               Society, development/Millennium Development Goals Indicators
    ## 955                                                                                               Society, development/Millennium Development Goals Indicators
    ## 956                                                                                               Society, development/Millennium Development Goals Indicators
    ## 957                                                                                               Society, development/Millennium Development Goals Indicators
    ## 958                                                                                               Society, development/Millennium Development Goals Indicators
    ## 959                                                                                               Society, development/Millennium Development Goals Indicators
    ## 960                                                                                               Society, development/Millennium Development Goals Indicators
    ## 961                                                                                               Society, development/Millennium Development Goals Indicators
    ## 962                                                                                               Society, development/Millennium Development Goals Indicators
    ## 963                                                                                               Society, development/Millennium Development Goals Indicators
    ## 964                                                                                               Society, development/Millennium Development Goals Indicators
    ## 965                                                                                               Society, development/Millennium Development Goals Indicators
    ## 966                                                                                               Society, development/Millennium Development Goals Indicators
    ## 967                                                                                               Society, development/Millennium Development Goals Indicators
    ## 968                                                                                               Society, development/Millennium Development Goals Indicators
    ## 969                                                                                               Society, development/Millennium Development Goals Indicators
    ## 970                                                                                               Society, development/Millennium Development Goals Indicators
    ## 971                                                                                               Society, development/Millennium Development Goals Indicators
    ## 972                                                                                               Society, development/Millennium Development Goals Indicators
    ## 973                                                                                               Society, development/Millennium Development Goals Indicators
    ## 974                                                                                               Society, development/Millennium Development Goals Indicators
    ## 975                                                                                               Society, development/Millennium Development Goals Indicators
    ## 976                                                                                               Society, development/Millennium Development Goals Indicators
    ## 977                                                                                               Society, development/Millennium Development Goals Indicators
    ## 978                                                                                               Society, development/Millennium Development Goals Indicators
    ## 979                                                                                               Society, development/Millennium Development Goals Indicators
    ## 980                                                                                               Society, development/Millennium Development Goals Indicators
    ## 981                                                                                               Society, development/Millennium Development Goals Indicators
    ## 982                                                                                               Society, development/Millennium Development Goals Indicators
    ## 983                                                                                               Society, development/Millennium Development Goals Indicators
    ## 984                                                                                               Society, development/Millennium Development Goals Indicators
    ## 985                                                                                               Society, development/Millennium Development Goals Indicators
    ## 986                                                                                               Society, development/Millennium Development Goals Indicators
    ## 987                                                                                               Society, development/Millennium Development Goals Indicators
    ## 988                                                                                               Society, development/Millennium Development Goals Indicators
    ## 989                                                                                               Society, development/Millennium Development Goals Indicators
    ## 990                                                                                               Society, development/Millennium Development Goals Indicators
    ## 991                                                                                               Society, development/Millennium Development Goals Indicators
    ## 992                                                                                               Society, development/Millennium Development Goals Indicators
    ## 993                                                                                               Society, development/Millennium Development Goals Indicators
    ## 994                                                                                               Society, development/Millennium Development Goals Indicators
    ## 995                                                                                               Society, development/Millennium Development Goals Indicators
    ## 996                                                                                               Society, development/Millennium Development Goals Indicators
    ## 997                                                                                               Society, development/Millennium Development Goals Indicators
    ## 998                                                                                               Society, development/Millennium Development Goals Indicators
    ## 999                                                                                               Society, development/Millennium Development Goals Indicators
    ## 1000                                                                                              Society, development/Millennium Development Goals Indicators
    ## 1001                                                                                              Society, development/Millennium Development Goals Indicators
    ## 1002                                                                                              Society, development/Millennium Development Goals Indicators
    ## 1003                                                                                              Society, development/Millennium Development Goals Indicators
    ## 1004                                                                                              Society, development/Millennium Development Goals Indicators
    ## 1005                                                                                              Society, development/Millennium Development Goals Indicators
    ## 1006                                                                                              Society, development/Millennium Development Goals Indicators
    ## 1007                                                                                              Society, development/Millennium Development Goals Indicators
    ## 1008                                                                                              Society, development/Millennium Development Goals Indicators
    ## 1009                                                                                              Society, development/Millennium Development Goals Indicators
    ## 1010                                                                                              Society, development/Millennium Development Goals Indicators
    ## 1011                                                                                              Society, development/Millennium Development Goals Indicators
    ## 1012                                                                                              Society, development/Millennium Development Goals Indicators
    ## 1013                                                                                              Society, development/Millennium Development Goals Indicators
    ## 1014                                                                                              Society, development/Millennium Development Goals Indicators
    ## 1015                                                                                              Society, development/Millennium Development Goals Indicators
    ## 1016                                                                                              Society, development/Millennium Development Goals Indicators
    ## 1017                                                                                              Society, development/Millennium Development Goals Indicators
    ## 1018                                                                                              Society, development/Millennium Development Goals Indicators
    ## 1019                                                                                              Society, development/Millennium Development Goals Indicators
    ## 1020                                                                                                    Society, development/Monasteries, Temples and Churches
    ## 1021                                                                                                    Society, development/Monasteries, Temples and Churches
    ## 1022                                                                                                    Society, development/Monasteries, Temples and Churches
    ## 1023                                                                                    Society, development/Poverty, inequality and minimum subsistence level
    ## 1024                                                                                    Society, development/Poverty, inequality and minimum subsistence level
    ## 1025                                                                                    Society, development/Poverty, inequality and minimum subsistence level
    ## 1026                                                                                    Society, development/Poverty, inequality and minimum subsistence level
    ## 1027                                                                                    Society, development/Poverty, inequality and minimum subsistence level
    ## 1028                                                                                    Society, development/Poverty, inequality and minimum subsistence level
    ## 1029                                                                                    Society, development/Poverty, inequality and minimum subsistence level
    ## 1030                                                                                    Society, development/Poverty, inequality and minimum subsistence level
    ## 1031                                                                                    Society, development/Poverty, inequality and minimum subsistence level
    ## 1032                                                                                    Society, development/Poverty, inequality and minimum subsistence level
    ## 1033                                                                                    Society, development/Poverty, inequality and minimum subsistence level
    ## 1034                                                                                                         Society, development/Social Insurance and Welfare
    ## 1035                                                                                                         Society, development/Social Insurance and Welfare
    ## 1036                                                                                                         Society, development/Social Insurance and Welfare
    ## 1037                                                                                                         Society, development/Social Insurance and Welfare
    ## 1038                                                                                                         Society, development/Social Insurance and Welfare
    ## 1039                                                                                                         Society, development/Social Insurance and Welfare
    ## 1040                                                                                                         Society, development/Social Insurance and Welfare
    ## 1041                                                                                                         Society, development/Social Insurance and Welfare
    ## 1042                                                                                                         Society, development/Social Insurance and Welfare
    ## 1043                                                                                                         Society, development/Social Insurance and Welfare
    ## 1044                                                                                                         Society, development/Social Insurance and Welfare
    ## 1045                                                                                                         Society, development/Social Insurance and Welfare
    ## 1046                                                                                                         Society, development/Social Insurance and Welfare
    ## 1047                                                                                                         Society, development/Social Insurance and Welfare
    ## 1048                                                                                                         Society, development/Social Insurance and Welfare
    ## 1049                                                                                                         Society, development/Social Insurance and Welfare
    ## 1050                                                                                                         Society, development/Social Insurance and Welfare
    ## 1051                                                                                                         Society, development/Social Insurance and Welfare
    ## 1052                                                                                                         Society, development/Social Insurance and Welfare
    ## 1053                                                                                                         Society, development/Social Insurance and Welfare
    ## 1054                                                                                                         Society, development/Social Insurance and Welfare
    ## 1055                                                                                                         Society, development/Social Insurance and Welfare
    ## 1056                                                                                                         Society, development/Social Insurance and Welfare
    ## 1057                                                                                                         Society, development/Social Insurance and Welfare
    ## 1058                                                                                                         Society, development/Social Insurance and Welfare
    ## 1059                                                                                                         Society, development/Social Insurance and Welfare
    ## 1060                                                                                                        Society, development/Sustainable Development Goals
    ## 1061                                                                    Economy, environment/Money and Finance/MAIN INDICATORS OF INSURANCE SECTOR, by quarter
    ## 1062                                                                    Economy, environment/Money and Finance/MAIN INDICATORS OF INSURANCE SECTOR, by quarter
    ## 1063                                                                    Economy, environment/Money and Finance/MAIN INDICATORS OF INSURANCE SECTOR, by quarter
    ## 1064                                                                    Economy, environment/Money and Finance/MAIN INDICATORS OF INSURANCE SECTOR, by quarter
    ## 1065                                                                    Economy, environment/Money and Finance/MAIN INDICATORS OF INSURANCE SECTOR, by quarter
    ## 1066                                                                                 Economy, environment/Producer price index/INDUSTRIAL PRODUCER PRICE INDEX
    ## 1067                                                                                 Economy, environment/Producer price index/INDUSTRIAL PRODUCER PRICE INDEX
    ## 1068                                                                    Economy, environment/Producer price index/PRODUCER PRICE INDEX OF ACCOMMODATION SECTOR
    ## 1069                                                                    Economy, environment/Producer price index/PRODUCER PRICE INDEX OF ACCOMMODATION SECTOR
    ## 1070                                                                    Economy, environment/Producer price index/PRODUCER PRICE INDEX OF ACCOMMODATION SECTOR
    ## 1071                                                        Economy, environment/Producer price index/PRODUCER PRICE INDEX OF FOOD AND BEVERAGE SERVICE SECTOR
    ## 1072                                                        Economy, environment/Producer price index/PRODUCER PRICE INDEX OF FOOD AND BEVERAGE SERVICE SECTOR
    ## 1073                                                        Economy, environment/Producer price index/PRODUCER PRICE INDEX OF FOOD AND BEVERAGE SERVICE SECTOR
    ## 1074                                                    Economy, environment/Producer price index/PRODUCER PRICE INDEX OF INFORMATION AND COMMUNICATION SECTOR
    ## 1075                                                    Economy, environment/Producer price index/PRODUCER PRICE INDEX OF INFORMATION AND COMMUNICATION SECTOR
    ## 1076                                                    Economy, environment/Producer price index/PRODUCER PRICE INDEX OF INFORMATION AND COMMUNICATION SECTOR
    ## 1077                                                                   Economy, environment/Producer price index/PRODUCER PRICE INDEX OF TRANSPORTATION SECTOR
    ## 1078                                                                   Economy, environment/Producer price index/PRODUCER PRICE INDEX OF TRANSPORTATION SECTOR
    ## 1079                                                                   Economy, environment/Producer price index/PRODUCER PRICE INDEX OF TRANSPORTATION SECTOR
    ## 1080                                                                                     Education, health/Births, deaths/NUMBER OF MATERNAL DEATHS, by region
    ## 1081                                                                                     Education, health/Births, deaths/NUMBER OF MATERNAL DEATHS, by region
    ## 1082                                                                       Education, health/Main indicators for Health sector/NUMBER OF INPATIENTS, by region
    ## 1083                                                                       Education, health/Main indicators for Health sector/NUMBER OF INPATIENTS, by region
    ## 1084                                     Industry, service/Construction/CONSTRUCTION, CAPITAL REPAIRS PERFORMED BY DOMESTIC ENTERPRISES, by soum and district,
    ## 1085                                     Industry, service/Construction/CONSTRUCTION, CAPITAL REPAIRS PERFORMED BY DOMESTIC ENTERPRISES, by soum and district,
    ## 1086                                                                                          Industry, service/Intellectual property/CERTIFIED UTILITY MODELS
    ## 1087                                                                                          Industry, service/Intellectual property/CERTIFIED UTILITY MODELS
    ## 1088                                                                                       Industry, service/Intellectual property/COPYRIGHT, BY TYPES OF WORK
    ## 1089                                                                                       Industry, service/Intellectual property/COPYRIGHT, BY TYPES OF WORK
    ## 1090                                                                          Industry, service/Intellectual property/PATENT APPLICATIONS FOR INDUSTRAL DESIGN
    ## 1091                                                                          Industry, service/Intellectual property/PATENT APPLICATIONS FOR INDUSTRAL DESIGN
    ## 1092                                                                                 Industry, service/Intellectual property/PATENT APPLICATIONS FOR INVENTION
    ## 1093                                                                                 Industry, service/Intellectual property/PATENT APPLICATIONS FOR INVENTION
    ## 1094                                                                                                  Industry, service/Intellectual property/PATENTS IN FORCE
    ## 1095                                                                                                  Industry, service/Intellectual property/PATENTS IN FORCE
    ## 1096                                                                                                  Industry, service/Intellectual property/PATENTS IN FORCE
    ## 1097                                                                                  Industry, service/Intellectual property/THE WORKS PROTECTED BY COPYRIGHT
    ## 1098                                                                                  Industry, service/Intellectual property/THE WORKS PROTECTED BY COPYRIGHT
    ## 1099                                                                                  Industry, service/Intellectual property/TOTAL APPLICATIONS FOR TRADEMARK
    ## 1100                                                                                  Industry, service/Intellectual property/TOTAL APPLICATIONS FOR TRADEMARK
    ## 1101                                                                              Industry, service/Intellectual property/TOTAL APPLICATIONS FOR UTILITY MODEL
    ## 1102                                                                              Industry, service/Intellectual property/TOTAL APPLICATIONS FOR UTILITY MODEL
    ## 1103                                                                                               Industry, service/Intellectual property/TOTAL PATENT GRANTS
    ## 1104                                                                                               Industry, service/Intellectual property/TOTAL PATENT GRANTS
    ## 1105                                                                                                Industry, service/Intellectual property/TRADEMARK IN FORCE
    ## 1106                                                                                                Industry, service/Intellectual property/TRADEMARK IN FORCE
    ## 1107                                                                                            Industry, service/Intellectual property/TRADEMARK REGISTRATION
    ## 1108                                                                                            Industry, service/Intellectual property/TRADEMARK REGISTRATION
    ## 1109                                                                                           Industry, service/Intellectual property/UTILITY MODELS IN FORCE
    ## 1110                                                                                           Industry, service/Intellectual property/UTILITY MODELS IN FORCE
    ## 1111                                           Industry, service/Telecommunication/KEY INDICATORS OF COMMUNICATION SERVICES, by region, aimags and the Capital
    ## 1112                                           Industry, service/Telecommunication/KEY INDICATORS OF COMMUNICATION SERVICES, by region, aimags and the Capital
    ## 1113                                                   Industry, service/Telecommunication/NUMBER OF CABLE TELEVISION USERS, by region, aimags and the Capital
    ## 1114                                                   Industry, service/Telecommunication/NUMBER OF CABLE TELEVISION USERS, by region, aimags and the Capital
    ## 1115                                             Industry, service/Telecommunication/NUMBER OF INTERNET USERS AND COMPUTERS, by region, aimags and the Capital
    ## 1116                                             Industry, service/Telecommunication/NUMBER OF INTERNET USERS AND COMPUTERS, by region, aimags and the Capital
    ## 1117                                                                                   Industry, service/Telecommunication/POSTAL SERVICE INDICATORS, by types
    ## 1118                                                                                   Industry, service/Telecommunication/POSTAL SERVICE INDICATORS, by types
    ## 1119                                 Industry, service/Telecommunication/REVENUE OF COMMUNICATION SECTOR, by type of operation, region, aimags and the Capital
    ## 1120                                 Industry, service/Telecommunication/REVENUE OF COMMUNICATION SECTOR, by type of operation, region, aimags and the Capital
    ## 1121                                                                      Industry, service/Tourism/INBOUND AND OUTBOUND PASSENGERS by Name of border crossing
    ## 1122                                                                      Industry, service/Tourism/INBOUND AND OUTBOUND PASSENGERS by Name of border crossing
    ## 1123                                                                      Industry, service/Tourism/INBOUND AND OUTBOUND PASSENGERS by Name of border crossing
    ## 1124                                                          Industry, service/Tourism/Number of inbound and outbound foreign passengers by country of origin
    ## 1125                                                          Industry, service/Tourism/Number of inbound and outbound foreign passengers by country of origin
    ## 1126                                                          Industry, service/Tourism/Number of inbound and outbound foreign passengers by country of origin
    ## 1127                                                           Industry, service/Tourism/NUMBER OF INBOUND PASSENGERS by border crossings and purpose of visit
    ## 1128                                                           Industry, service/Tourism/NUMBER OF INBOUND PASSENGERS by border crossings and purpose of visit
    ## 1129                                                           Industry, service/Tourism/NUMBER OF INBOUND PASSENGERS by border crossings and purpose of visit
    ## 1130                                                                                           Industry, service/Tourism/NUMBER OF INBOUND TOURISTS by country
    ## 1131                                                                                           Industry, service/Tourism/NUMBER OF INBOUND TOURISTS by country
    ## 1132                                                                                           Industry, service/Tourism/NUMBER OF INBOUND TOURISTS by country
    ## 1133                                                          Industry, service/Tourism/NUMBER OF OUTBOUND MONGOLIAN, by border crossings and purpose of visit
    ## 1134                                                          Industry, service/Tourism/NUMBER OF OUTBOUND MONGOLIAN, by border crossings and purpose of visit
    ## 1135                                                        Industry, service/Trade, hotel and restaurant/INCOME OF THE FOOD SECTOR, by Aimag and Capital City
    ## 1136                                                        Industry, service/Trade, hotel and restaurant/INCOME OF THE FOOD SECTOR, by Aimag and Capital City
    ## 1137                                                       Industry, service/Trade, hotel and restaurant/INCOME OF THE HOTEL SECTOR, by Aimag and Capital City
    ## 1138                                                       Industry, service/Trade, hotel and restaurant/INCOME OF THE HOTEL SECTOR, by Aimag and Capital City
    ## 1139                                               Industry, service/Transportation/CARRIED PASSENGERS, by air transport, by each direction and national level
    ## 1140                                               Industry, service/Transportation/CARRIED PASSENGERS, by air transport, by each direction and national level
    ## 1141                                               Industry, service/Transportation/CARRIED PASSENGERS, by air transport, by each direction and national level
    ## 1142                                                                       Industry, service/Transportation/KEY INDICATORS OF AIR TRANSPORT, by national level
    ## 1143                                                                       Industry, service/Transportation/KEY INDICATORS OF AIR TRANSPORT, by national level
    ## 1144                                                                       Industry, service/Transportation/KEY INDICATORS OF AIR TRANSPORT, by national level
    ## 1145                                                                      Industry, service/Transportation/KEY INDICATORS OF AUTO TRANSPORT, by national level
    ## 1146                                                                      Industry, service/Transportation/KEY INDICATORS OF AUTO TRANSPORT, by national level
    ## 1147                                                                   Industry, service/Transportation/KEY INDICATORS OF RAILWAY TRANSPORT, by national level
    ## 1148                                                                   Industry, service/Transportation/KEY INDICATORS OF RAILWAY TRANSPORT, by national level
    ## 1149                                                                   Industry, service/Transportation/KEY INDICATORS OF RAILWAY TRANSPORT, by national level
    ## 1150                                                                       Labour, business/Labour/EMPLOYEES WORKING ABROAD ON A CONTRACTUAL BASIS, by country
    ## 1151                                                                       Labour, business/Labour/EMPLOYEES WORKING ABROAD ON A CONTRACTUAL BASIS, by country
    ## 1152                                                           Labour, business/Labour/EMPLOYMENT INDICATORS OF POPULATION AGED 15 AND OVER, by national level
    ## 1153                                                           Labour, business/Labour/EMPLOYMENT INDICATORS OF POPULATION AGED 15 AND OVER, by national level
    ## 1154                                                         Labour, business/Labour/EMPLOYMENT TO POPULATION RATIO, by sex, age group, aimags and the Capital
    ## 1155                                                         Labour, business/Labour/EMPLOYMENT TO POPULATION RATIO, by sex, age group, aimags and the Capital
    ## 1156                                                        Labour, business/Labour/EMPLOYMENT, by economic activities, sex, age group, aimags and the Capital
    ## 1157                                                        Labour, business/Labour/EMPLOYMENT, by economic activities, sex, age group, aimags and the Capital
    ## 1158                                                         Labour, business/Labour/EMPLOYMENT, by occupation, sex, age group, region, aimags and the Capital
    ## 1159                                                         Labour, business/Labour/EMPLOYMENT, by occupation, sex, age group, region, aimags and the Capital
    ## 1160                                        Labour, business/Labour/EMPLOYMENT, by status in employment, age group, region, aimags and the Capital,  1985-2018
    ## 1161                                        Labour, business/Labour/EMPLOYMENT, by status in employment, age group, region, aimags and the Capital,  1985-2018
    ## 1162                                   Labour, business/Labour/EMPLOYMENT, by status in employment, sex, age group, region, aimags and the Capital, since 2019
    ## 1163                                   Labour, business/Labour/EMPLOYMENT, by status in employment, sex, age group, region, aimags and the Capital, since 2019
    ## 1164                                                                                           Labour, business/Labour/INJURED PERSONS, by economic activities
    ## 1165                                                                                           Labour, business/Labour/INJURED PERSONS, by economic activities
    ## 1166                                                                        Labour, business/Labour/INJURED PERSONS, by economic activities, type of accidents
    ## 1167                                                                        Labour, business/Labour/INJURED PERSONS, by economic activities, type of accidents
    ## 1168                                                        Labour, business/Labour/LABOUR FORCE PARTICIPATION RATE, by sex, age group, aimags and the Capital
    ## 1169                                                        Labour, business/Labour/LABOUR FORCE PARTICIPATION RATE, by sex, age group, aimags and the Capital
    ## 1170                                                                           Labour, business/Labour/LABOUR FORCE, by sex, age group, aimags and the Capital
    ## 1171                                                                           Labour, business/Labour/LABOUR FORCE, by sex, age group, aimags and the Capital
    ## 1172                                                           Labour, business/Labour/LABOUR UNDERUTILIZATION RATE, by sex, age group, aimags and the Capital
    ## 1173                                                           Labour, business/Labour/LABOUR UNDERUTILIZATION RATE, by sex, age group, aimags and the Capital
    ## 1174                                                                Labour, business/Labour/LABOUR UNDERUTILIZATION, by sex, age group, aimags and the Capital
    ## 1175                                                                Labour, business/Labour/LABOUR UNDERUTILIZATION, by sex, age group, aimags and the Capital
    ## 1176                                                        Labour, business/Labour/OCCUPATIONAL ACCIDENT, ACUTE POISONINGS, by region, aimags and the Capital
    ## 1177                                                        Labour, business/Labour/OCCUPATIONAL ACCIDENT, ACUTE POISONINGS, by region, aimags and the Capital
    ## 1178                                            Labour, business/Labour/PERSONS OUTSIDE THE LABOUR FORCE, by reason, by sex, age group, aimags and the Capital
    ## 1179                                            Labour, business/Labour/PERSONS OUTSIDE THE LABOUR FORCE, by reason, by sex, age group, aimags and the Capital
    ## 1180                                                                     Labour, business/Labour/UNEMPLOYED, by reason, sex, age group, aimags and the Capital
    ## 1181                                                                     Labour, business/Labour/UNEMPLOYED, by reason, sex, age group, aimags and the Capital
    ## 1182                                                                                    Labour, business/Wages/EMPLOYEES, by group of wages,and share to total
    ## 1183                                                                                    Labour, business/Wages/EMPLOYEES, by group of wages,and share to total
    ## 1184                                                                         Labour, business/Wages/MONTHLY AVERAGE NOMINAL WAGES , by legal status and gender
    ## 1185                                                                         Labour, business/Wages/MONTHLY AVERAGE NOMINAL WAGES , by legal status and gender
    ## 1186                                                                    Labour, business/Wages/MONTHLY AVERAGE NOMINAL WAGES , by type of ownership and gender
    ## 1187                                                                    Labour, business/Wages/MONTHLY AVERAGE NOMINAL WAGES , by type of ownership and gender
    ## 1188                                                      Labour, business/Wages/MONTHLY AVERAGE NOMINAL WAGES OF EMPLOYEE, by employees size class and gender
    ## 1189                                                      Labour, business/Wages/MONTHLY AVERAGE NOMINAL WAGES OF EMPLOYEE, by employees size class and gender
    ## 1190                                                                  Labour, business/Wages/MONTHLY AVERAGE NOMINAL WAGES, by division of economic activities
    ## 1191                                                                  Labour, business/Wages/MONTHLY AVERAGE NOMINAL WAGES, by division of economic activities
    ## 1192                                                                            Labour, business/Wages/MONTHLY AVERAGE NOMINAL WAGES, by occupation and gender
    ## 1193                                                                            Labour, business/Wages/MONTHLY AVERAGE NOMINAL WAGES, by occupation and gender
    ## 1194                                                        Labour, business/Wages/MONTHLY AVERAGE NOMINAL WAGES, by region, aimags and the Capital, by gender
    ## 1195                                                        Labour, business/Wages/MONTHLY AVERAGE NOMINAL WAGES, by region, aimags and the Capital, by gender
    ## 1196                                                                                                  Labour, business/Wages/MONTHLY MEDIAN WAGES OF EMPLOYEES
    ## 1197                                                                                                  Labour, business/Wages/MONTHLY MEDIAN WAGES OF EMPLOYEES
    ## 1198                                                                    Labour, business/Wages/REAL WAGE INDEX (2015=100), by divisions of economic activities
    ## 1199                                                                    Labour, business/Wages/REAL WAGE INDEX (2015=100), by divisions of economic activities
    ## 1200                                                   Society, development/Law and crime/CRIME CAUSED OF DAMAGES AND DAMAGES WERE RESTITUTED,  year and month
    ## 1201                                                   Society, development/Law and crime/CRIME CAUSED OF DAMAGES AND DAMAGES WERE RESTITUTED,  year and month
    ## 1202                             Society, development/Law and crime/NUMBER OF CRIMINAL CASES REGISTERED BY THE ANTI-CORRUPTION AGENCY, by Type, Month and Year
    ## 1203                             Society, development/Law and crime/NUMBER OF CRIMINAL CASES REGISTERED BY THE ANTI-CORRUPTION AGENCY, by Type, Month and Year
    ## 1204                                Society, development/Law and crime/NUMBER OF OFFENDERS, by region, aimag and the capital, sex , age group and month,  year
    ## 1205                                Society, development/Law and crime/NUMBER OF OFFENDERS, by region, aimag and the capital, sex , age group and month,  year
    ## 1206                                                           Society, development/Law and crime/NUMBER OF RECORDED CRIMES, by classification, year and month
    ## 1207                                                           Society, development/Law and crime/NUMBER OF RECORDED CRIMES, by classification, year and month
    ## 1208                                                      Society, development/Law and crime/NUMBER OF RECORDED CRIMES, by region, aimag and the capital, year
    ## 1209                                                      Society, development/Law and crime/NUMBER OF RECORDED CRIMES, by region, aimag and the capital, year
    ## 1210                                                                     Society, development/Law and crime/RECORDED CRIMES, by classification, year and month
    ## 1211                                                                     Society, development/Law and crime/RECORDED CRIMES, by classification, year and month
    ## 1212                                                          Society, development/Social Insurance and Welfare/EXPENDITURE OF SOCIAL SINSURANCE FUND, by type
    ## 1213                                                          Society, development/Social Insurance and Welfare/EXPENDITURE OF SOCIAL SINSURANCE FUND, by type
    ## 1214 Society, development/Social Insurance and Welfare/NUMBER OF PENSIONARIES, WHO RECEIPT PENSIONS FROM THE SOCIAL INSURANCE FUND, by type of pension, annual
    ## 1215 Society, development/Social Insurance and Welfare/NUMBER OF PENSIONARIES, WHO RECEIPT PENSIONS FROM THE SOCIAL INSURANCE FUND, by type of pension, annual
    ## 1216                                                     Society, development/Social Insurance and Welfare/PERSONS INVOLVED SOCIAL WELFARE ACTIVITIES, by type
    ## 1217                                                     Society, development/Social Insurance and Welfare/PERSONS INVOLVED SOCIAL WELFARE ACTIVITIES, by type
    ## 1218                                                               Society, development/Social Insurance and Welfare/REVENUE OF SOCIAL INSURANCE FUND, by type
    ## 1219                                                               Society, development/Social Insurance and Welfare/REVENUE OF SOCIAL INSURANCE FUND, by type
    ## 1220                                                                         Society, development/Social Insurance and Welfare/THE NUMBER OF INSURERS, by type
    ## 1221                                                                         Society, development/Social Insurance and Welfare/THE NUMBER OF INSURERS, by type
    ## 1222            Society, development/Social Insurance and Welfare/TOTAL AMOUNT OF GRANTED PENSIONS AND BENEFITS, SERVICES IN SOCIAL WELFARE ACTIVITES, by type
    ## 1223            Society, development/Social Insurance and Welfare/TOTAL AMOUNT OF GRANTED PENSIONS AND BENEFITS, SERVICES IN SOCIAL WELFARE ACTIVITES, by type
    ## 1224                                            Society, development/Social Insurance and Welfare/WHO RECEIPT PENSIONS FROM THE SOCIAL INSURANCE FUND, by type
    ## 1225                                            Society, development/Social Insurance and Welfare/WHO RECEIPT PENSIONS FROM THE SOCIAL INSURANCE FUND, by type
    ##                              px_file                       tbl_id
    ## 1              DT_NSO_0100_001V10.px           DT_NSO_0100_001V10
    ## 2               DT_NSO_0300_010V5.px            DT_NSO_0300_010V5
    ## 3                DT_NSO_0303_07V7.px             DT_NSO_0303_07V7
    ## 4                DT_NSO_0303_07V8.px             DT_NSO_0303_07V8
    ## 5                DT_NSO_0303_07V9.px             DT_NSO_0303_07V9
    ## 6               DT_NSO_0600_001V3.px            DT_NSO_0600_001V3
    ## 7               DT_NSO_0600_001V4.px            DT_NSO_0600_001V4
    ## 8               DT_NSO_0600_002V1.px            DT_NSO_0600_002V1
    ## 9              DT_NSO_0600_002V21.px           DT_NSO_0600_002V21
    ## 10             DT_NSO_0600_002V22.px           DT_NSO_0600_002V22
    ## 11             DT_NSO_0600_002V23.px           DT_NSO_0600_002V23
    ## 12             DT_NSO_0600_002V24.px           DT_NSO_0600_002V24
    ## 13             DT_NSO_0600_002V25.px           DT_NSO_0600_002V25
    ## 14             DT_NSO_0600_002V26.px           DT_NSO_0600_002V26
    ## 15              DT_NSO_0600_003V4.px            DT_NSO_0600_003V4
    ## 16              DT_NSO_0600_008V1.px            DT_NSO_0600_008V1
    ## 17              DT_NSO_0600_009V1.px            DT_NSO_0600_009V1
    ## 18              DT_NSO_0600_010V1.px            DT_NSO_0600_010V1
    ## 19              DT_NSO_0600_011V1.px            DT_NSO_0600_011V1
    ## 20              DT_NSO_0600_012V1.px            DT_NSO_0600_012V1
    ## 21              DT_NSO_0600_013V2.px            DT_NSO_0600_013V2
    ## 22              DT_NSO_0600_019V1.px            DT_NSO_0600_019V1
    ## 23             DT_NSO_2024_135V01.px           DT_NSO_2024_135V01
    ## 24             DT_NSO_2300_005V12.px           DT_NSO_2300_005V12
    ## 25              DT_NSO_2400_001V1.px            DT_NSO_2400_001V1
    ## 26              DT_NSO_2400_001V2.px            DT_NSO_2400_001V2
    ## 27              DT_NSO_2400_005V1.px            DT_NSO_2400_005V1
    ## 28              DT_NSO_2400_006V1.px            DT_NSO_2400_006V1
    ## 29              DT_NSO_2400_009V1.px            DT_NSO_2400_009V1
    ## 30              DT_NSO_2400_012V1.px            DT_NSO_2400_012V1
    ## 31              DT_NSO_2400_015V1.px            DT_NSO_2400_015V1
    ## 32              DT_NSO_2400_015V2.px            DT_NSO_2400_015V2
    ## 33              DT_NSO_2400_015V3.px            DT_NSO_2400_015V3
    ## 34              DT_NSO_2400_015V4.px            DT_NSO_2400_015V4
    ## 35              DT_NSO_2400_022V2.px            DT_NSO_2400_022V2
    ## 36              DT_NSO_2400_022V3.px            DT_NSO_2400_022V3
    ## 37              DT_NSO_2400_026V1.px            DT_NSO_2400_026V1
    ## 38              DT_NSO_2400_027V1.px            DT_NSO_2400_027V1
    ## 39              DT_NSO_2400_028V1.px            DT_NSO_2400_028V1
    ## 40              DT_NSO_2400_028V2.px            DT_NSO_2400_028V2
    ## 41             DT_NSO_2023_001V01.px           DT_NSO_2023_001V01
    ## 42             DT_NSO_2023_001V02.px           DT_NSO_2023_001V02
    ## 43             DT_NSO_2023_001V03.px           DT_NSO_2023_001V03
    ## 44             DT_NSO_2023_001V04.px           DT_NSO_2023_001V04
    ## 45             DT_NSO_2023_001V05.px           DT_NSO_2023_001V05
    ## 46             DT_NSO_2023_001V06.px           DT_NSO_2023_001V06
    ## 47              DT_NSO_2023_001V1.px            DT_NSO_2023_001V1
    ## 48              DT_NSO_2023_001V2.px            DT_NSO_2023_001V2
    ## 49              DT_NSO_2023_001V3.px            DT_NSO_2023_001V3
    ## 50              DT_NSO_2023_001V4.px            DT_NSO_2023_001V4
    ## 51              DT_NSO_2023_001V5.px            DT_NSO_2023_001V5
    ## 52              DT_NSO_3600_001V1.px            DT_NSO_3600_001V1
    ## 53              DT_NSO_3600_002V1.px            DT_NSO_3600_002V1
    ## 54              DT_NSO_3600_004V1.px            DT_NSO_3600_004V1
    ## 55              DT_NSO_3600_005V1.px            DT_NSO_3600_005V1
    ## 56              DT_NSO_3600_006V1.px            DT_NSO_3600_006V1
    ## 57              DT_NSO_3600_007V1.px            DT_NSO_3600_007V1
    ## 58              DT_NSO_3600_008V1.px            DT_NSO_3600_008V1
    ## 59            DT_NSO_1100_015V3_1.px          DT_NSO_1100_015V3_1
    ## 60       DT_NSO_1100_015V3_uliral.px     DT_NSO_1100_015V3_uliral
    ## 61        DT_NSO_1400_001V1_month.px      DT_NSO_1400_001V1_month
    ## 62         DT_NSO_1400_001V1_year.px       DT_NSO_1400_001V1_year
    ## 63              DT_NSO_1400_003V1.px            DT_NSO_1400_003V1
    ## 64        DT_NSO_1400_005V1_month.px      DT_NSO_1400_005V1_month
    ## 65         DT_NSO_1400_005V1_year.px       DT_NSO_1400_005V1_year
    ## 66        DT_NSO_1400_006V2_month.px      DT_NSO_1400_006V2_month
    ## 67         DT_NSO_1400_006V2_year.px       DT_NSO_1400_006V2_year
    ## 68              DT_NSO_1400_006V3.px            DT_NSO_1400_006V3
    ## 69        DT_NSO_1400_009V1_month.px      DT_NSO_1400_009V1_month
    ## 70         DT_NSO_1400_009V1_year.px       DT_NSO_1400_009V1_year
    ## 71        DT_NSO_1400_010V2_month.px      DT_NSO_1400_010V2_month
    ## 72         DT_NSO_1400_010V2_year.px       DT_NSO_1400_010V2_year
    ## 73              DT_NSO_1400_010V3.px            DT_NSO_1400_010V3
    ## 74              DT_NSO_1400_016V1.px            DT_NSO_1400_016V1
    ## 75              DT_NSO_1400_016V2.px            DT_NSO_1400_016V2
    ## 76              DT_NSO_0700_028V1.px            DT_NSO_0700_028V1
    ## 77              DT_NSO_0700_028V2.px            DT_NSO_0700_028V2
    ## 78              DT_NSO_0700_028V3.px            DT_NSO_0700_028V3
    ## 79              DT_NSO_0800_001V1.px            DT_NSO_0800_001V1
    ## 80              DT_NSO_0800_001V2.px            DT_NSO_0800_001V2
    ## 81              DT_NSO_0800_002V1.px            DT_NSO_0800_002V1
    ## 82              DT_NSO_0800_003V1.px            DT_NSO_0800_003V1
    ## 83              DT_NSO_0800_004V1.px            DT_NSO_0800_004V1
    ## 84              DT_NSO_0800_005V1.px            DT_NSO_0800_005V1
    ## 85              DT_NSO_0800_006V1.px            DT_NSO_0800_006V1
    ## 86              DT_NSO_0800_007V1.px            DT_NSO_0800_007V1
    ## 87              DT_NSO_0800_008V1.px            DT_NSO_0800_008V1
    ## 88              DT_NSO_0800_011V1.px            DT_NSO_0800_011V1
    ## 89              DT_NSO_0800_029V1.px            DT_NSO_0800_029V1
    ## 90              DT_NSO_0800_031V1.px            DT_NSO_0800_031V1
    ## 91               DT_NSO_0300_00V1.px             DT_NSO_0300_00V1
    ## 92               DT_NSO_0300_00V3.px             DT_NSO_0300_00V3
    ## 93               DT_NSO_0300_00V4.px             DT_NSO_0300_00V4
    ## 94              DT_NSO_0300_071V0.px            DT_NSO_0300_071V0
    ## 95              DT_NSO_1700_001V1.px            DT_NSO_1700_001V1
    ## 96              DT_NSO_1700_005V1.px            DT_NSO_1700_005V1
    ## 97              DT_NSO_0901_001V1.px            DT_NSO_0901_001V1
    ## 98              DT_NSO_0901_002V1.px            DT_NSO_0901_002V1
    ## 99              DT_NSO_0901_004V1.px            DT_NSO_0901_004V1
    ## 100             DT_NSO_0901_005V1.px            DT_NSO_0901_005V1
    ## 101           DT_NSO_1500_004V3_1.px          DT_NSO_1500_004V3_1
    ## 102           DT_NSO_1500_004V3_2.px          DT_NSO_1500_004V3_2
    ## 103           DT_NSO_1500_004V4_1.px          DT_NSO_1500_004V4_1
    ## 104           DT_NSO_1500_004V4_2.px          DT_NSO_1500_004V4_2
    ## 105           DT_NSO_1500_005V3_1.px          DT_NSO_1500_005V3_1
    ## 106           DT_NSO_1500_005V3_2.px          DT_NSO_1500_005V3_2
    ## 107           DT_NSO_1500_005V4_1.px          DT_NSO_1500_005V4_1
    ## 108           DT_NSO_1500_005V4_2.px          DT_NSO_1500_005V4_2
    ## 109           DT_NSO_0300_2024V01.px          DT_NSO_0300_2024V01
    ## 110           DT_NSO_0300_2024V02.px          DT_NSO_0300_2024V02
    ## 111             DT_NSO_0700_001V2.px            DT_NSO_0700_001V2
    ## 112             DT_NSO_0700_001V3.px            DT_NSO_0700_001V3
    ## 113             DT_NSO_0700_002V2.px            DT_NSO_0700_002V2
    ## 114             DT_NSO_0700_005V1.px            DT_NSO_0700_005V1
    ## 115             DT_NSO_0700_006V1.px            DT_NSO_0700_006V1
    ## 116             DT_NSO_0700_007V1.px            DT_NSO_0700_007V1
    ## 117             DT_NSO_0700_007V2.px            DT_NSO_0700_007V2
    ## 118             DT_NSO_0700_008V1.px            DT_NSO_0700_008V1
    ## 119             DT_NSO_0700_009V1.px            DT_NSO_0700_009V1
    ## 120             DT_NSO_0700_010V1.px            DT_NSO_0700_010V1
    ## 121             DT_NSO_0700_018V1.px            DT_NSO_0700_018V1
    ## 122             DT_NSO_0700_021V1.px            DT_NSO_0700_021V1
    ## 123             DT_NSO_0700_022V1.px            DT_NSO_0700_022V1
    ## 124             DT_NSO_0700_023V1.px            DT_NSO_0700_023V1
    ## 125             DT_NSO_0700_024V1.px            DT_NSO_0700_024V1
    ## 126             DT_NSO_0700_027V1.px            DT_NSO_0700_027V1
    ## 127             DT_NSO_0700_030V1.px            DT_NSO_0700_030V1
    ## 128             DT_NSO_0700_031V1.px            DT_NSO_0700_031V1
    ## 129             DT_NSO_0700_032V1.px            DT_NSO_0700_032V1
    ## 130             DT_NSO_0500_001V1.px            DT_NSO_0500_001V1
    ## 131            DT_NSO_0500_001V12.px           DT_NSO_0500_001V12
    ## 132             DT_NSO_0500_001V2.px            DT_NSO_0500_001V2
    ## 133             DT_NSO_0500_002V1.px            DT_NSO_0500_002V1
    ## 134      DT_NSO_0500_003V1_annual.px     DT_NSO_0500_003V1_annual
    ## 135     DT_NSO_0500_003V1_quarter.px    DT_NSO_0500_003V1_quarter
    ## 136             DT_NSO_0500_004V1.px            DT_NSO_0500_004V1
    ## 137             DT_NSO_0500_005V1.px            DT_NSO_0500_005V1
    ## 138             DT_NSO_0500_005V2.px            DT_NSO_0500_005V2
    ## 139             DT_NSO_0500_006V1.px            DT_NSO_0500_006V1
    ## 140             DT_NSO_0500_007V1.px            DT_NSO_0500_007V1
    ## 141             DT_NSO_0500_009V1.px            DT_NSO_0500_009V1
    ## 142             DT_NSO_0500_010V1.px            DT_NSO_0500_010V1
    ## 143             DT_NSO_0500_011V1.px            DT_NSO_0500_011V1
    ## 144             DT_NSO_0500_012V1.px            DT_NSO_0500_012V1
    ## 145             DT_NSO_0500_020V1.px            DT_NSO_0500_020V1
    ## 146             DT_NSO_0500_021V1.px            DT_NSO_0500_021V1
    ## 147             DT_NSO_0500_021V2.px            DT_NSO_0500_021V2
    ## 148             DT_NSO_0500_022V1.px            DT_NSO_0500_022V1
    ## 149           DT_NSO_0500_022V1-1.px          DT_NSO_0500_022V1-1
    ## 150             DT_NSO_0500_022V2.px            DT_NSO_0500_022V2
    ## 151             DT_NSO_3100_003V9.px            DT_NSO_3100_003V9
    ## 152             DT_NSO_3100_009V8.px            DT_NSO_3100_009V8
    ## 153             DT_NSO_3200_001V9.px            DT_NSO_3200_001V9
    ## 154             DT_NSO_3200_005V9.px            DT_NSO_3200_005V9
    ## 155             DT_NSO_0500_010V2.px            DT_NSO_0500_010V2
    ## 156             DT_NSO_0500_011V3.px            DT_NSO_0500_011V3
    ## 157             DT_NSO_2500_001V2.px            DT_NSO_2500_001V2
    ## 158             DT_NSO_0300_023V1.px            DT_NSO_0300_023V1
    ## 159             DT_NSO_0300_029V1.px            DT_NSO_0300_029V1
    ## 160             DT_NSO_0300_032V1.px            DT_NSO_0300_032V1
    ## 161             DT_NSO_2100_001V1.px            DT_NSO_2100_001V1
    ## 162             DT_NSO_2100_002V3.px            DT_NSO_2100_002V3
    ## 163             DT_NSO_2100_005V1.px            DT_NSO_2100_005V1
    ## 164             DT_NSO_2100_008V3.px            DT_NSO_2100_008V3
    ## 165             DT_NSO_2100_011V1.px            DT_NSO_2100_011V1
    ## 166             DT_NSO_2100_012V1.px            DT_NSO_2100_012V1
    ## 167             DT_NSO_2100_014V1.px            DT_NSO_2100_014V1
    ## 168             DT_NSO_2100_014V2.px            DT_NSO_2100_014V2
    ## 169             DT_NSO_2100_014V4.px            DT_NSO_2100_014V4
    ## 170             DT_NSO_2100_014V5.px            DT_NSO_2100_014V5
    ## 171             DT_NSO_2100_015V1.px            DT_NSO_2100_015V1
    ## 172             DT_NSO_2100_015V2.px            DT_NSO_2100_015V2
    ## 173             DT_NSO_2100_017V2.px            DT_NSO_2100_017V2
    ## 174             DT_NSO_2100_017V3.px            DT_NSO_2100_017V3
    ## 175             DT_NSO_2100_017V4.px            DT_NSO_2100_017V4
    ## 176             DT_NSO_2100_018V5.px            DT_NSO_2100_018V5
    ## 177             DT_NSO_2100_018V6.px            DT_NSO_2100_018V6
    ## 178             DT_NSO_2100_023V1.px            DT_NSO_2100_023V1
    ## 179             DT_NSO_2100_027V1.px            DT_NSO_2100_027V1
    ## 180             DT_NSO_2100_027V2.px            DT_NSO_2100_027V2
    ## 181             DT_NSO_2100_027V3.px            DT_NSO_2100_027V3
    ## 182             DT_NSO_2100_029V1.px            DT_NSO_2100_029V1
    ## 183             DT_NSO_2100_030V2.px            DT_NSO_2100_030V2
    ## 184             DT_NSO_2100_036V1.px            DT_NSO_2100_036V1
    ## 185             DT_NSO_2100_037V1.px            DT_NSO_2100_037V1
    ## 186             DT_NSO_2100_038V1.px            DT_NSO_2100_038V1
    ## 187             DT_NSO_2100_039V1.px            DT_NSO_2100_039V1
    ## 188             DT_NSO_2100_040V1.px            DT_NSO_2100_040V1
    ## 189             DT_NSO_2100_040V2.px            DT_NSO_2100_040V2
    ## 190             DT_NSO_2100_041V2.px            DT_NSO_2100_041V2
    ## 191             DT_NSO_2100_041V3.px            DT_NSO_2100_041V3
    ## 192             DT_NSO_2100_046V1.px            DT_NSO_2100_046V1
    ## 193             DT_NSO_2100_047V1.px            DT_NSO_2100_047V1
    ## 194             DT_NSO_2100_048V1.px            DT_NSO_2100_048V1
    ## 195             DT_NSO_2100_049V1.px            DT_NSO_2100_049V1
    ## 196             DT_NSO_2100_050V1.px            DT_NSO_2100_050V1
    ## 197             DT_NSO_2100_051V1.px            DT_NSO_2100_051V1
    ## 198             DT_NSO_2100_013V1.px            DT_NSO_2100_013V1
    ## 199             DT_NSO_2100_020V2.px            DT_NSO_2100_020V2
    ## 200             DT_NSO_2100_028V1.px            DT_NSO_2100_028V1
    ## 201             DT_NSO_2100_035V1.px            DT_NSO_2100_035V1
    ## 202             DT_NSO_2100_044V1.px            DT_NSO_2100_044V1
    ## 203             DT_NSO_2100_045V1.px            DT_NSO_2100_045V1
    ## 204             DT_NSO_2001_001V1.px            DT_NSO_2001_001V1
    ## 205             DT_NSO_2001_001V2.px            DT_NSO_2001_001V2
    ## 206             DT_NSO_2001_002V1.px            DT_NSO_2001_002V1
    ## 207             DT_NSO_2001_002V2.px            DT_NSO_2001_002V2
    ## 208             DT_NSO_2001_003V1.px            DT_NSO_2001_003V1
    ## 209             DT_NSO_2001_004V1.px            DT_NSO_2001_004V1
    ## 210             DT_NSO_2001_018V1.px            DT_NSO_2001_018V1
    ## 211             DT_NSO_2001_019V1.px            DT_NSO_2001_019V1
    ## 212             DT_NSO_2001_020V1.px            DT_NSO_2001_020V1
    ## 213             DT_NSO_2002_014V1.px            DT_NSO_2002_014V1
    ## 214             DT_NSO_2002_015V1.px            DT_NSO_2002_015V1
    ## 215             DT_NSO_2002_056V1.px            DT_NSO_2002_056V1
    ## 216             DT_NSO_2002_057V1.px            DT_NSO_2002_057V1
    ## 217             DT_NSO_2002_057V2.px            DT_NSO_2002_057V2
    ## 218             DT_NSO_2002_057V3.px            DT_NSO_2002_057V3
    ## 219             DT_NSO_2002_058V1.px            DT_NSO_2002_058V1
    ## 220             DT_NSO_2002_059V1.px            DT_NSO_2002_059V1
    ## 221             DT_NSO_2002_065V1.px            DT_NSO_2002_065V1
    ## 222             DT_NSO_2002_065V2.px            DT_NSO_2002_065V2
    ## 223             DT_NSO_2002_012V1.px            DT_NSO_2002_012V1
    ## 224             DT_NSO_2002_055V1.px            DT_NSO_2002_055V1
    ## 225             DT_NSO_2002_066V2.px            DT_NSO_2002_066V2
    ## 226             DT_NSO_2002_067V1.px            DT_NSO_2002_067V1
    ## 227             DT_NSO_2002_068V1.px            DT_NSO_2002_068V1
    ## 228             DT_NSO_2002_069V2.px            DT_NSO_2002_069V2
    ## 229             DT_NSO_2100_033V1.px            DT_NSO_2100_033V1
    ## 230             DT_NSO_2100_033V2.px            DT_NSO_2100_033V2
    ## 231            DT_NSO_2100_30V001.px           DT_NSO_2100_30V001
    ## 232            DT_NSO_2100_30V002.px           DT_NSO_2100_30V002
    ## 233              DT_NSO_2100_30V2.px             DT_NSO_2100_30V2
    ## 234            DT_NSO_0300_071V01.px           DT_NSO_0300_071V01
    ## 235            DT_NSO_0300_071V02.px           DT_NSO_0300_071V02
    ## 236            DT_NSO_0300_071V03.px           DT_NSO_0300_071V03
    ## 237             DT_NSO_2100_005V2.px            DT_NSO_2100_005V2
    ## 238             DT_NSO_2100_005V3.px            DT_NSO_2100_005V3
    ## 239             DT_NSO_2100_006V1.px            DT_NSO_2100_006V1
    ## 240             DT_NSO_2100_006V2.px            DT_NSO_2100_006V2
    ## 241             DT_NSO_2100_007V1.px            DT_NSO_2100_007V1
    ## 242             DT_NSO_2100_008V2.px            DT_NSO_2100_008V2
    ## 243             DT_NSO_2100_009V1.px            DT_NSO_2100_009V1
    ## 244             DT_NSO_2100_010V1.px            DT_NSO_2100_010V1
    ## 245             DT_NSO_2100_010V3.px            DT_NSO_2100_010V3
    ## 246             DT_NSO_2100_026V1.px            DT_NSO_2100_026V1
    ## 247             DT_NSO_2100_030V1.px            DT_NSO_2100_030V1
    ## 248             DT_NSO_2100_032V1.px            DT_NSO_2100_032V1
    ## 249             DT_NSO_2100_033V1.px            DT_NSO_2100_033V1
    ## 250             DT_NSO_2100_042V1.px            DT_NSO_2100_042V1
    ## 251             DT_NSO_2100_043V1.px            DT_NSO_2100_043V1
    ## 252             DT_NSO_2001_010V1.px            DT_NSO_2001_010V1
    ## 253             DT_NSO_2001_010V2.px            DT_NSO_2001_010V2
    ## 254             DT_NSO_2001_011V1.px            DT_NSO_2001_011V1
    ## 255             DT_NSO_2001_011V3.px            DT_NSO_2001_011V3
    ## 256             DT_NSO_2001_012V1.px            DT_NSO_2001_012V1
    ## 257             DT_NSO_2001_021V1.px            DT_NSO_2001_021V1
    ## 258             DT_NSO_2001_022V1.px            DT_NSO_2001_022V1
    ## 259             DT_NSO_2002_026V1.px            DT_NSO_2002_026V1
    ## 260             DT_NSO_2002_058V2.px            DT_NSO_2002_058V2
    ## 261             DT_NSO_2002_058V4.px            DT_NSO_2002_058V4
    ## 262             DT_NSO_2001_013V1.px            DT_NSO_2001_013V1
    ## 263             DT_NSO_2001_013V2.px            DT_NSO_2001_013V2
    ## 264             DT_NSO_2001_014V1.px            DT_NSO_2001_014V1
    ## 265             DT_NSO_2001_015V2.px            DT_NSO_2001_015V2
    ## 266             DT_NSO_2001_016V1.px            DT_NSO_2001_016V1
    ## 267             DT_NSO_2001_024V1.px            DT_NSO_2001_024V1
    ## 268             DT_NSO_2001_024V2.px            DT_NSO_2001_024V2
    ## 269             DT_NSO_2001_024V3.px            DT_NSO_2001_024V3
    ## 270             DT_NSO_2001_006V1.px            DT_NSO_2001_006V1
    ## 271             DT_NSO_2001_007V1.px            DT_NSO_2001_007V1
    ## 272             DT_NSO_2001_008V1.px            DT_NSO_2001_008V1
    ## 273             DT_NSO_2001_008V2.px            DT_NSO_2001_008V2
    ## 274             DT_NSO_2001_023V1.px            DT_NSO_2001_023V1
    ## 275             DT_NSO_2001_023V2.px            DT_NSO_2001_023V2
    ## 276             DT_NSO_2001_023V3.px            DT_NSO_2001_023V3
    ## 277             DT_NSO_2001_023V4.px            DT_NSO_2001_023V4
    ## 278             DT_NSO_0100_T0011.px            DT_NSO_0100_T0011
    ## 279             DT_NSO_0100_T0021.px            DT_NSO_0100_T0021
    ## 280             DT_NSO_0100_01T01.px            DT_NSO_0100_01T01
    ## 281            DT_NSO_0100_01T010.px           DT_NSO_0100_01T010
    ## 282            DT_NSO_0100_01T011.px           DT_NSO_0100_01T011
    ## 283            DT_NSO_0100_01T012.px           DT_NSO_0100_01T012
    ## 284            DT_NSO_0100_01T013.px           DT_NSO_0100_01T013
    ## 285            DT_NSO_0100_01T014.px           DT_NSO_0100_01T014
    ## 286            DT_NSO_0100_01T015.px           DT_NSO_0100_01T015
    ## 287            DT_NSO_0100_01T016.px           DT_NSO_0100_01T016
    ## 288            DT_NSO_0100_01T017.px           DT_NSO_0100_01T017
    ## 289            DT_NSO_0100_01T018.px           DT_NSO_0100_01T018
    ## 290            DT_NSO_0100_01T019.px           DT_NSO_0100_01T019
    ## 291             DT_NSO_0100_01T02.px            DT_NSO_0100_01T02
    ## 292             DT_NSO_0100_01T03.px            DT_NSO_0100_01T03
    ## 293             DT_NSO_0100_01T04.px            DT_NSO_0100_01T04
    ## 294             DT_NSO_0100_01T05.px            DT_NSO_0100_01T05
    ## 295             DT_NSO_0100_01T06.px            DT_NSO_0100_01T06
    ## 296             DT_NSO_0100_01T07.px            DT_NSO_0100_01T07
    ## 297             DT_NSO_0100_01T08.px            DT_NSO_0100_01T08
    ## 298             DT_NSO_0100_01T09.px            DT_NSO_0100_01T09
    ## 299            DT_NSO_0100_01TT01.px           DT_NSO_0100_01TT01
    ## 300            DT_NSO_0100_01TT02.px           DT_NSO_0100_01TT02
    ## 301            DT_NSO_0100_01TT03.px           DT_NSO_0100_01TT03
    ## 302            DT_NSO_0100_01TT04.px           DT_NSO_0100_01TT04
    ## 303            DT_NSO_0100_01TT05.px           DT_NSO_0100_01TT05
    ## 304            DT_NSO_0100_01TT06.px           DT_NSO_0100_01TT06
    ## 305            DT_NSO_0100_01TT07.px           DT_NSO_0100_01TT07
    ## 306            DT_NSO_0100_01TT08.px           DT_NSO_0100_01TT08
    ## 307            DT_NSO_0100_01TT09.px           DT_NSO_0100_01TT09
    ## 308           DT_NSO_0100_01TTT01.px          DT_NSO_0100_01TTT01
    ## 309           DT_NSO_0100_01TTT02.px          DT_NSO_0100_01TTT02
    ## 310           DT_NSO_0100_01TTT03.px          DT_NSO_0100_01TTT03
    ## 311           DT_NSO_0100_01TTT04.px          DT_NSO_0100_01TTT04
    ## 312            DT_NSO_0100_01TB08.px           DT_NSO_0100_01TB08
    ## 313            DT_NSO_0100_01TB09.px           DT_NSO_0100_01TB09
    ## 314            DT_NSO_0100_01TB10.px           DT_NSO_0100_01TB10
    ## 315            DT_NSO_0100_01TB11.px           DT_NSO_0100_01TB11
    ## 316            DT_NSO_0100_01TB12.px           DT_NSO_0100_01TB12
    ## 317            DT_NSO_0100_01TB13.px           DT_NSO_0100_01TB13
    ## 318            DT_NSO_0100_01TB14.px           DT_NSO_0100_01TB14
    ## 319           DT_NSO_0100_01TTT05.px          DT_NSO_0100_01TTT05
    ## 320           DT_NSO_0100_01TTT06.px          DT_NSO_0100_01TTT06
    ## 321           DT_NSO_0100_01TTT07.px          DT_NSO_0100_01TTT07
    ## 322           DT_NSO_0100_01TTT08.px          DT_NSO_0100_01TTT08
    ## 323            DT_NSO_0100_01TB01.px           DT_NSO_0100_01TB01
    ## 324              DT_NSO_0100_T006.px             DT_NSO_0100_T006
    ## 325              DT_NSO_0100_T008.px             DT_NSO_0100_T008
    ## 326               DT_NSO_0100_T01.px              DT_NSO_0100_T01
    ## 327               DT_NSO_0100_T02.px              DT_NSO_0100_T02
    ## 328               DT_NSO_0100_T03.px              DT_NSO_0100_T03
    ## 329               DT_NSO_0100_T04.px              DT_NSO_0100_T04
    ## 330               DT_NSO_0100_T05.px              DT_NSO_0100_T05
    ## 331            DT_NSO_0100_01TB04.px           DT_NSO_0100_01TB04
    ## 332            DT_NSO_0100_01TB05.px           DT_NSO_0100_01TB05
    ## 333            DT_NSO_0100_01TB06.px           DT_NSO_0100_01TB06
    ## 334            DT_NSO_0100_01TB07.px           DT_NSO_0100_01TB07
    ## 335             DT_NSO_0100_T0010.px            DT_NSO_0100_T0010
    ## 336              DT_NSO_0100_T007.px             DT_NSO_0100_T007
    ## 337              DT_NSO_0100_T009.px             DT_NSO_0100_T009
    ## 338             DT_NSO_0100_01T39.px            DT_NSO_0100_01T39
    ## 339             DT_NSO_0100_01T40.px            DT_NSO_0100_01T40
    ## 340             DT_NSO_0100_01T41.px            DT_NSO_0100_01T41
    ## 341             DT_NSO_0100_01T42.px            DT_NSO_0100_01T42
    ## 342             DT_NSO_0100_01T20.px            DT_NSO_0100_01T20
    ## 343             DT_NSO_0100_01T21.px            DT_NSO_0100_01T21
    ## 344             DT_NSO_0100_01T22.px            DT_NSO_0100_01T22
    ## 345             DT_NSO_0100_01T23.px            DT_NSO_0100_01T23
    ## 346             DT_NSO_0100_01T24.px            DT_NSO_0100_01T24
    ## 347             DT_NSO_0100_01T25.px            DT_NSO_0100_01T25
    ## 348             DT_NSO_0100_01T26.px            DT_NSO_0100_01T26
    ## 349             DT_NSO_0100_01T27.px            DT_NSO_0100_01T27
    ## 350             DT_NSO_0100_01T28.px            DT_NSO_0100_01T28
    ## 351             DT_NSO_0100_01T29.px            DT_NSO_0100_01T29
    ## 352             DT_NSO_0100_01T30.px            DT_NSO_0100_01T30
    ## 353             DT_NSO_0100_T0022.px            DT_NSO_0100_T0022
    ## 354             DT_NSO_0100_T0023.px            DT_NSO_0100_T0023
    ## 355             DT_NSO_0100_T0024.px            DT_NSO_0100_T0024
    ## 356             DT_NSO_0100_T0025.px            DT_NSO_0100_T0025
    ## 357             DT_NSO_0100_T0026.px            DT_NSO_0100_T0026
    ## 358             DT_NSO_0100_T0027.px            DT_NSO_0100_T0027
    ## 359            DT_NSO_0100_01TB02.px           DT_NSO_0100_01TB02
    ## 360            DT_NSO_0100_01TB03.px           DT_NSO_0100_01TB03
    ## 361              DT_NSO_0100_T001.px             DT_NSO_0100_T001
    ## 362              DT_NSO_0100_T002.px             DT_NSO_0100_T002
    ## 363              DT_NSO_0100_T003.px             DT_NSO_0100_T003
    ## 364             DT_NSO_0100_T0031.px            DT_NSO_0100_T0031
    ## 365              DT_NSO_0100_T004.px             DT_NSO_0100_T004
    ## 366              DT_NSO_0100_T010.px             DT_NSO_0100_T010
    ## 367               DT_NSO_0100_T06.px              DT_NSO_0100_T06
    ## 368               DT_NSO_0100_T07.px              DT_NSO_0100_T07
    ## 369               DT_NSO_0100_T08.px              DT_NSO_0100_T08
    ## 370               DT_NSO_0100_T09.px              DT_NSO_0100_T09
    ## 371             DT_NSO_0100_01T31.px            DT_NSO_0100_01T31
    ## 372             DT_NSO_0100_01T32.px            DT_NSO_0100_01T32
    ## 373             DT_NSO_0100_01T33.px            DT_NSO_0100_01T33
    ## 374             DT_NSO_0100_01T34.px            DT_NSO_0100_01T34
    ## 375             DT_NSO_0100_01T35.px            DT_NSO_0100_01T35
    ## 376             DT_NSO_0100_01T36.px            DT_NSO_0100_01T36
    ## 377             DT_NSO_0100_01T37.px            DT_NSO_0100_01T37
    ## 378             DT_NSO_0100_01T38.px            DT_NSO_0100_01T38
    ## 379             DT_NSO_0100_01T43.px            DT_NSO_0100_01T43
    ## 380             DT_NSO_0100_01T44.px            DT_NSO_0100_01T44
    ## 381             DT_NSO_0100_01T45.px            DT_NSO_0100_01T45
    ## 382             DT_NSO_1001_033V1.px            DT_NSO_1001_033V1
    ## 383             DT_NSO_1001_035V3.px            DT_NSO_1001_035V3
    ## 384             DT_NSO_1001_036V2.px            DT_NSO_1001_036V2
    ## 385             DT_NSO_1001_038V2.px            DT_NSO_1001_038V2
    ## 386             DT_NSO_1001_038V3.px            DT_NSO_1001_038V3
    ## 387             DT_NSO_1002_001V1.px            DT_NSO_1002_001V1
    ## 388             DT_NSO_1002_001V3.px            DT_NSO_1002_001V3
    ## 389             DT_NSO_1002_001V4.px            DT_NSO_1002_001V4
    ## 390             DT_NSO_1002_001V5.px            DT_NSO_1002_001V5
    ## 391             DT_NSO_1002_002V1.px            DT_NSO_1002_002V1
    ## 392             DT_NSO_1002_003V1.px            DT_NSO_1002_003V1
    ## 393             DT_NSO_1002_004V1.px            DT_NSO_1002_004V1
    ## 394             DT_NSO_1002_005V1.px            DT_NSO_1002_005V1
    ## 395             DT_NSO_1002_006V1.px            DT_NSO_1002_006V1
    ## 396             DT_NSO_1002_007V1.px            DT_NSO_1002_007V1
    ## 397             DT_NSO_1002_008V1.px            DT_NSO_1002_008V1
    ## 398             DT_NSO_1002_009V1.px            DT_NSO_1002_009V1
    ## 399             DT_NSO_1002_009V2.px            DT_NSO_1002_009V2
    ## 400             DT_NSO_1002_011V1.px            DT_NSO_1002_011V1
    ## 401             DT_NSO_1002_013V1.px            DT_NSO_1002_013V1
    ## 402             DT_NSO_1002_014V1.px            DT_NSO_1002_014V1
    ## 403             DT_NSO_0902_002V1.px            DT_NSO_0902_002V1
    ## 404             DT_NSO_0902_003V1.px            DT_NSO_0902_003V1
    ## 405             DT_NSO_0902_004V1.px            DT_NSO_0902_004V1
    ## 406             DT_NSO_0902_005V1.px            DT_NSO_0902_005V1
    ## 407             DT_NSO_0902_006V1.px            DT_NSO_0902_006V1
    ## 408             DT_NSO_0902_009V1.px            DT_NSO_0902_009V1
    ## 409             DT_NSO_1100_015V2.px            DT_NSO_1100_015V2
    ## 410            DT_NSO_0300_071V04.px           DT_NSO_0300_071V04
    ## 411            DT_NSO_0300_071V05.px           DT_NSO_0300_071V05
    ## 412             DT_NSO_2002_001V1.px            DT_NSO_2002_001V1
    ## 413             DT_NSO_2002_002V1.px            DT_NSO_2002_002V1
    ## 414             DT_NSO_2002_003V1.px            DT_NSO_2002_003V1
    ## 415             DT_NSO_2002_004V1.px            DT_NSO_2002_004V1
    ## 416             DT_NSO_2002_005V1.px            DT_NSO_2002_005V1
    ## 417             DT_NSO_2002_008V1.px            DT_NSO_2002_008V1
    ## 418             DT_NSO_2002_009V1.px            DT_NSO_2002_009V1
    ## 419             DT_NSO_2002_010V1.px            DT_NSO_2002_010V1
    ## 420             DT_NSO_1100_001V1.px            DT_NSO_1100_001V1
    ## 421             DT_NSO_1100_001V2.px            DT_NSO_1100_001V2
    ## 422             DT_NSO_1100_002V2.px            DT_NSO_1100_002V2
    ## 423             DT_NSO_1100_004V1.px            DT_NSO_1100_004V1
    ## 424             DT_NSO_1100_006V2.px            DT_NSO_1100_006V2
    ## 425             DT_NSO_1100_007V1.px            DT_NSO_1100_007V1
    ## 426             DT_NSO_1100_008V1.px            DT_NSO_1100_008V1
    ## 427             DT_NSO_1100_009V1.px            DT_NSO_1100_009V1
    ## 428             DT_NSO_1100_010V1.px            DT_NSO_1100_010V1
    ## 429             DT_NSO_1100_011V1.px            DT_NSO_1100_011V1
    ## 430             DT_NSO_1100_013V1.px            DT_NSO_1100_013V1
    ## 431             DT_NSO_1100_015V1.px            DT_NSO_1100_015V1
    ## 432            DT_NSO_1100_015V12.px           DT_NSO_1100_015V12
    ## 433             DT_NSO_1100_016V1.px            DT_NSO_1100_016V1
    ## 434             DT_NSO_1100_016V4.px            DT_NSO_1100_016V4
    ## 435             DT_NSO_1100_016V5.px            DT_NSO_1100_016V5
    ## 436             DT_NSO_1100_032V1.px            DT_NSO_1100_032V1
    ## 437             DT_NSO_1001_001V1.px            DT_NSO_1001_001V1
    ## 438             DT_NSO_1001_006V2.px            DT_NSO_1001_006V2
    ## 439             DT_NSO_1001_007V1.px            DT_NSO_1001_007V1
    ## 440             DT_NSO_1001_008V1.px            DT_NSO_1001_008V1
    ## 441             DT_NSO_1001_011V1.px            DT_NSO_1001_011V1
    ## 442             DT_NSO_1001_013V3.px            DT_NSO_1001_013V3
    ## 443             DT_NSO_1001_015V3.px            DT_NSO_1001_015V3
    ## 444             DT_NSO_1001_016V3.px            DT_NSO_1001_016V3
    ## 445             DT_NSO_1001_017V1.px            DT_NSO_1001_017V1
    ## 446             DT_NSO_1001_018V1.px            DT_NSO_1001_018V1
    ## 447             DT_NSO_1001_019V1.px            DT_NSO_1001_019V1
    ## 448             DT_NSO_1001_021V1.px            DT_NSO_1001_021V1
    ## 449             DT_NSO_1001_024V1.px            DT_NSO_1001_024V1
    ## 450             DT_NSO_1001_029V1.px            DT_NSO_1001_029V1
    ## 451             DT_NSO_1001_030V1.px            DT_NSO_1001_030V1
    ## 452             DT_NSO_1001_040V2.px            DT_NSO_1001_040V2
    ## 453             DT_NSO_1001_041V1.px            DT_NSO_1001_041V1
    ## 454             DT_NSO_1001_042V2.px            DT_NSO_1001_042V2
    ## 455             DT_NSO_1001_052V2.px            DT_NSO_1001_052V2
    ## 456             DT_NSO_2002_006V1.px            DT_NSO_2002_006V1
    ## 457             DT_NSO_2002_007V1.px            DT_NSO_2002_007V1
    ## 458             DT_NSO_1800_005V2.px            DT_NSO_1800_005V2
    ## 459             DT_NSO_1800_005V3.px            DT_NSO_1800_005V3
    ## 460             DT_NSO_1800_006V1.px            DT_NSO_1800_006V1
    ## 461           DT_NSO_1800_006V202.px          DT_NSO_1800_006V202
    ## 462             DT_NSO_1800_007V1.px            DT_NSO_1800_007V1
    ## 463           DT_NSO_1800_007V202.px          DT_NSO_1800_007V202
    ## 464           DT_NSO_1800_008V202.px          DT_NSO_1800_008V202
    ## 465           DT_NSO_1800_009V202.px          DT_NSO_1800_009V202
    ## 466           DT_NSO_1800_010V202.px          DT_NSO_1800_010V202
    ## 467             DT_NSO_1600_001V1.px            DT_NSO_1600_001V1
    ## 468       DT_NSO_1600_002V1_month.px      DT_NSO_1600_002V1_month
    ## 469        DT_NSO_1600_002V1_year.px       DT_NSO_1600_002V1_year
    ## 470             DT_NSO_1200_012V4.px            DT_NSO_1200_012V4
    ## 471             DT_NSO_1200_013V1.px            DT_NSO_1200_013V1
    ## 472             DT_NSO_1200_013V2.px            DT_NSO_1200_013V2
    ## 473             DT_NSO_1200_013V3.px            DT_NSO_1200_013V3
    ## 474             DT_NSO_1200_013V4.px            DT_NSO_1200_013V4
    ## 475             DT_NSO_1200_013V5.px            DT_NSO_1200_013V5
    ## 476             DT_NSO_0200_006V1.px            DT_NSO_0200_006V1
    ## 477             DT_NSO_0200_007V1.px            DT_NSO_0200_007V1
    ## 478             DT_NSO_0400_039V0.px            DT_NSO_0400_039V0
    ## 479             DT_NSO_0400_042V1.px            DT_NSO_0400_042V1
    ## 480            DT_NSO_3300_202405.px           DT_NSO_3300_202405
    ## 481           DT_NSO_3300_2024052.px          DT_NSO_3300_2024052
    ## 482             DT_NSO_0400_045V1.px            DT_NSO_0400_045V1
    ## 483             DT_NSO_0400_046V1.px            DT_NSO_0400_046V1
    ## 484             DT_NSO_0400_047V1.px            DT_NSO_0400_047V1
    ## 485             DT_NSO_0400_048V1.px            DT_NSO_0400_048V1
    ## 486             DT_NSO_0400_049V1.px            DT_NSO_0400_049V1
    ## 487             DT_NSO_0400_050V1.px            DT_NSO_0400_050V1
    ## 488             DT_NSO_0400_051V1.px            DT_NSO_0400_051V1
    ## 489             DT_NSO_0400_052V1.px            DT_NSO_0400_052V1
    ## 490             DT_NSO_0400_053V1.px            DT_NSO_0400_053V1
    ## 491             DT_NSO_0400_054V1.px            DT_NSO_0400_054V1
    ## 492             DT_NSO_0400_055V1.px            DT_NSO_0400_055V1
    ## 493             DT_NSO_0400_056V1.px            DT_NSO_0400_056V1
    ## 494             DT_NSO_0400_057V1.px            DT_NSO_0400_057V1
    ## 495             DT_NSO_0400_058V1.px            DT_NSO_0400_058V1
    ## 496             DT_NSO_0400_059V1.px            DT_NSO_0400_059V1
    ## 497             DT_NSO_0400_060V1.px            DT_NSO_0400_060V1
    ## 498             DT_NSO_0400_061V1.px            DT_NSO_0400_061V1
    ## 499             DT_NSO_0400_063V1.px            DT_NSO_0400_063V1
    ## 500             DT_NSO_0400_064V1.px            DT_NSO_0400_064V1
    ## 501             DT_NSO_0400_065V1.px            DT_NSO_0400_065V1
    ## 502             DT_NSO_0400_066V1.px            DT_NSO_0400_066V1
    ## 503             DT_NSO_0400_067V1.px            DT_NSO_0400_067V1
    ## 504             DT_NSO_0400_068V1.px            DT_NSO_0400_068V1
    ## 505             DT_NSO_0400_002V4.px            DT_NSO_0400_002V4
    ## 506             DT_NSO_0400_002V5.px            DT_NSO_0400_002V5
    ## 507             DT_NSO_0400_002V6.px            DT_NSO_0400_002V6
    ## 508             DT_NSO_0400_002V7.px            DT_NSO_0400_002V7
    ## 509             DT_NSO_0400_002V8.px            DT_NSO_0400_002V8
    ## 510             DT_NSO_0400_082V1.px            DT_NSO_0400_082V1
    ## 511             DT_NSO_0400_082V5.px            DT_NSO_0400_082V5
    ## 512             DT_NSO_0400_082V6.px            DT_NSO_0400_082V6
    ## 513             DT_NSO_0400_082V7.px            DT_NSO_0400_082V7
    ## 514            DT_NSO_0400_39V1_2.px           DT_NSO_0400_39V1_2
    ## 515              DT_NSO_0400_40V1.px             DT_NSO_0400_40V1
    ## 516            DT_NSO_0400_41V1_2.px           DT_NSO_0400_41V1_2
    ## 517              DT_NSO_0400_42V1.px             DT_NSO_0400_42V1
    ## 518             DT_NSO_0500_001V6.px            DT_NSO_0500_001V6
    ## 519            DT_NSO_0500_001V10.px           DT_NSO_0500_001V10
    ## 520             DT_NSO_0500_001V2.px            DT_NSO_0500_001V2
    ## 521             DT_NSO_0500_001V9.px            DT_NSO_0500_001V9
    ## 522               DT_NSO_BR_01V11.px              DT_NSO_BR_01V11
    ## 523               DT_NSO_BR_01V22.px              DT_NSO_BR_01V22
    ## 524               DT_NSO_BR_01V33.px              DT_NSO_BR_01V33
    ## 525             DT_NSO_2600_001V5.px            DT_NSO_2600_001V5
    ## 526           DT_NSO_2600_001V5_1.px          DT_NSO_2600_001V5_1
    ## 527             DT_NSO_2600_003V1.px            DT_NSO_2600_003V1
    ## 528             DT_NSO_2600_005V2.px            DT_NSO_2600_005V2
    ## 529             DT_NSO_2600_008V1.px            DT_NSO_2600_008V1
    ## 530             DT_NSO_2600_009V1.px            DT_NSO_2600_009V1
    ## 531             DT_NSO_2600_010V2.px            DT_NSO_2600_010V2
    ## 532             DT_NSO_2600_011V1.px            DT_NSO_2600_011V1
    ## 533             DT_NSO_2600_011V2.px            DT_NSO_2600_011V2
    ## 534             DT_NSO_2600_011V3.px            DT_NSO_2600_011V3
    ## 535             DT_NSO_2600_014V1.px            DT_NSO_2600_014V1
    ## 536             DT_NSO_2600_014V2.px            DT_NSO_2600_014V2
    ## 537             DT_NSO_2600_014V3.px            DT_NSO_2600_014V3
    ## 538             DT_NSO_2600_014V4.px            DT_NSO_2600_014V4
    ## 539           DT_NSO_2600_014V4_1.px          DT_NSO_2600_014V4_1
    ## 540             DT_NSO_2600_015V1.px            DT_NSO_2600_015V1
    ## 541             DT_NSO_2600_015V2.px            DT_NSO_2600_015V2
    ## 542             DT_NSO_2600_015V3.px            DT_NSO_2600_015V3
    ## 543             DT_NSO_2600_015V4.px            DT_NSO_2600_015V4
    ## 544             DT_NSO_2600_015V5.px            DT_NSO_2600_015V5
    ## 545           DT_NSO_2600_015V5_1.px          DT_NSO_2600_015V5_1
    ## 546             DT_NSO_2600_016V1.px            DT_NSO_2600_016V1
    ## 547             DT_NSO_2600_016V2.px            DT_NSO_2600_016V2
    ## 548             DT_NSO_2600_016V3.px            DT_NSO_2600_016V3
    ## 549             DT_NSO_2600_016V4.px            DT_NSO_2600_016V4
    ## 550             DT_NSO_2600_017V1.px            DT_NSO_2600_017V1
    ## 551             DT_NSO_2600_018V1.px            DT_NSO_2600_018V1
    ## 552             DT_NSO_0300_001V2.px            DT_NSO_0300_001V2
    ## 553             DT_NSO_0300_001V3.px            DT_NSO_0300_001V3
    ## 554             DT_NSO_0300_002V1.px            DT_NSO_0300_002V1
    ## 555             DT_NSO_0300_002V4.px            DT_NSO_0300_002V4
    ## 556             DT_NSO_0300_003V1.px            DT_NSO_0300_003V1
    ## 557             DT_NSO_0300_004V1.px            DT_NSO_0300_004V1
    ## 558             DT_NSO_0300_004V5.px            DT_NSO_0300_004V5
    ## 559             DT_NSO_0300_006V1.px            DT_NSO_0300_006V1
    ## 560             DT_NSO_0300_006V2.px            DT_NSO_0300_006V2
    ## 561             DT_NSO_0300_006V5.px            DT_NSO_0300_006V5
    ## 562             DT_NSO_0300_007V1.px            DT_NSO_0300_007V1
    ## 563             DT_NSO_0300_008V1.px            DT_NSO_0300_008V1
    ## 564             DT_NSO_0300_010V1.px            DT_NSO_0300_010V1
    ## 565             DT_NSO_0300_011V3.px            DT_NSO_0300_011V3
    ## 566             DT_NSO_0300_014V1.px            DT_NSO_0300_014V1
    ## 567             DT_NSO_0300_027V1.px            DT_NSO_0300_027V1
    ## 568             DT_NSO_0300_033V1.px            DT_NSO_0300_033V1
    ## 569             DT_NSO_0300_034V1.px            DT_NSO_0300_034V1
    ## 570             DT_NSO_0300_034V2.px            DT_NSO_0300_034V2
    ## 571             DT_NSO_0300_035V1.px            DT_NSO_0300_035V1
    ## 572             DT_NSO_0300_035V2.px            DT_NSO_0300_035V2
    ## 573             DT_NSO_0300_040V1.px            DT_NSO_0300_040V1
    ## 574             DT_NSO_0300_067V2.px            DT_NSO_0300_067V2
    ## 575             DT_NSO_0300_068V2.px            DT_NSO_0300_068V2
    ## 576             DT_NSO_0300_077V2.px            DT_NSO_0300_077V2
    ## 577             DT_NSO_3300_044V1.px            DT_NSO_3300_044V1
    ## 578             DT_NSO_3300_045V1.px            DT_NSO_3300_045V1
    ## 579             DT_NSO_0300_001V1.px            DT_NSO_0300_001V1
    ## 580             DT_NSO_0300_013V1.px            DT_NSO_0300_013V1
    ## 581             DT_NSO_0300_013V2.px            DT_NSO_0300_013V2
    ## 582             DT_NSO_0300_013V3.px            DT_NSO_0300_013V3
    ## 583             DT_NSO_0300_013V4.px            DT_NSO_0300_013V4
    ## 584             DT_NSO_0300_013V5.px            DT_NSO_0300_013V5
    ## 585             DT_NSO_0300_013V6.px            DT_NSO_0300_013V6
    ## 586             DT_NSO_0300_015V1.px            DT_NSO_0300_015V1
    ## 587             DT_NSO_0300_016V1.px            DT_NSO_0300_016V1
    ## 588             DT_NSO_0300_016V2.px            DT_NSO_0300_016V2
    ## 589             DT_NSO_0300_016V3.px            DT_NSO_0300_016V3
    ## 590             DT_NSO_0300_018V1.px            DT_NSO_0300_018V1
    ## 591             DT_NSO_0300_018V2.px            DT_NSO_0300_018V2
    ## 592             DT_NSO_0300_019V1.px            DT_NSO_0300_019V1
    ## 593             DT_NSO_0300_019V6.px            DT_NSO_0300_019V6
    ## 594             DT_NSO_0300_020V1.px            DT_NSO_0300_020V1
    ## 595             DT_NSO_0300_020V3.px            DT_NSO_0300_020V3
    ## 596             DT_NSO_0300_021V1.px            DT_NSO_0300_021V1
    ## 597             DT_NSO_0300_022V1.px            DT_NSO_0300_022V1
    ## 598             DT_NSO_0300_023V1.px            DT_NSO_0300_023V1
    ## 599             DT_NSO_0300_023V3.px            DT_NSO_0300_023V3
    ## 600             DT_NSO_0300_023V4.px            DT_NSO_0300_023V4
    ## 601             DT_NSO_0300_024V1.px            DT_NSO_0300_024V1
    ## 602             DT_NSO_0300_024V2.px            DT_NSO_0300_024V2
    ## 603             DT_NSO_0300_029V1.px            DT_NSO_0300_029V1
    ## 604             DT_NSO_0300_029V3.px            DT_NSO_0300_029V3
    ## 605             DT_NSO_0300_030V1.px            DT_NSO_0300_030V1
    ## 606             DT_NSO_0300_032V1.px            DT_NSO_0300_032V1
    ## 607             DT_NSO_0300_032V3.px            DT_NSO_0300_032V3
    ## 608             DT_NSO_0300_036V1.px            DT_NSO_0300_036V1
    ## 609             DT_NSO_0300_036V2.px            DT_NSO_0300_036V2
    ## 610             DT_NSO_0300_037V1.px            DT_NSO_0300_037V1
    ## 611             DT_NSO_0300_038V1.px            DT_NSO_0300_038V1
    ## 612             DT_NSO_0300_038V3.px            DT_NSO_0300_038V3
    ## 613             DT_NSO_0300_038V4.px            DT_NSO_0300_038V4
    ## 614             DT_NSO_0300_039V1.px            DT_NSO_0300_039V1
    ## 615             DT_NSO_0300_051V2.px            DT_NSO_0300_051V2
    ## 616             DT_NSO_0300_051V3.px            DT_NSO_0300_051V3
    ## 617             DT_NSO_0300_052V1.px            DT_NSO_0300_052V1
    ## 618             DT_NSO_0300_052V2.px            DT_NSO_0300_052V2
    ## 619             DT_NSO_1001_022V1.px            DT_NSO_1001_022V1
    ## 620             DT_NSO_1001_022V4.px            DT_NSO_1001_022V4
    ## 621             DT_NSO_1001_025V1.px            DT_NSO_1001_025V1
    ## 622             DT_NSO_1001_027V1.px            DT_NSO_1001_027V1
    ## 623             DT_NSO_1001_031V1.px            DT_NSO_1001_031V1
    ## 624             DT_NSO_1001_044V1.px            DT_NSO_1001_044V1
    ## 625             DT_NSO_1700_001V2.px            DT_NSO_1700_001V2
    ## 626             DT_NSO_1700_004V1.px            DT_NSO_1700_004V1
    ## 627             DT_NSO_3500_001V1.px            DT_NSO_3500_001V1
    ## 628             DT_NSO_3500_002V1.px            DT_NSO_3500_002V1
    ## 629             DT_NSO_3500_003V0.px            DT_NSO_3500_003V0
    ## 630             DT_NSO_3500_003V1.px            DT_NSO_3500_003V1
    ## 631             DT_NSO_3500_003V2.px            DT_NSO_3500_003V2
    ## 632             DT_NSO_3500_005V1.px            DT_NSO_3500_005V1
    ## 633             DT_NSO_3500_006V1.px            DT_NSO_3500_006V1
    ## 634            DT_NSO_0300_076V11.px           DT_NSO_0300_076V11
    ## 635            DT_NSO_0300_076V12.px           DT_NSO_0300_076V12
    ## 636            DT_NSO_0300_076V13.px           DT_NSO_0300_076V13
    ## 637             DT_NSO_0100_001V1.px            DT_NSO_0100_001V1
    ## 638             DT_NSO_0100_002V1.px            DT_NSO_0100_002V1
    ## 639             DT_NSO_0100_003V1.px            DT_NSO_0100_003V1
    ## 640             DT_NSO_0100_004V1.px            DT_NSO_0100_004V1
    ## 641             DT_NSO_1001_033V1.px            DT_NSO_1001_033V1
    ## 642             DT_NSO_1001_036V2.px            DT_NSO_1001_036V2
    ## 643             DT_NSO_1002_001V3.px            DT_NSO_1002_001V3
    ## 644             DT_NSO_1002_014V1.px            DT_NSO_1002_014V1
    ## 645           1.DT_NSO_0902_002V1.px          1.DT_NSO_0902_002V1
    ## 646           2.DT_NSO_0902_008V1.px          2.DT_NSO_0902_008V1
    ## 647           3.DT_NSO_0902_009V1.px          3.DT_NSO_0902_009V1
    ## 648             DT_NSO_0902_002V1.px            DT_NSO_0902_002V1
    ## 649             DT_NSO_3900_002V1.px            DT_NSO_3900_002V1
    ## 650             DT_NSO_3900_004V2.px            DT_NSO_3900_004V2
    ## 651             DT_NSO_3900_004V3.px            DT_NSO_3900_004V3
    ## 652             DT_NSO_3900_004V4.px            DT_NSO_3900_004V4
    ## 653             DT_NSO_3900_004V5.px            DT_NSO_3900_004V5
    ## 654             DT_NSO_3900_004V6.px            DT_NSO_3900_004V6
    ## 655             DT_NSO_3900_004V7.px            DT_NSO_3900_004V7
    ## 656             DT_NSO_3900_004V8.px            DT_NSO_3900_004V8
    ## 657             DT_NSO_2001_001V1.px            DT_NSO_2001_001V1
    ## 658             DT_NSO_2001_001V2.px            DT_NSO_2001_001V2
    ## 659             DT_NSO_2001_002V1.px            DT_NSO_2001_002V1
    ## 660             DT_NSO_2001_002V2.px            DT_NSO_2001_002V2
    ## 661             DT_NSO_2001_004V1.px            DT_NSO_2001_004V1
    ## 662             DT_NSO_2001_006V1.px            DT_NSO_2001_006V1
    ## 663             DT_NSO_2001_008V2.px            DT_NSO_2001_008V2
    ## 664             DT_NSO_2001_010V1.px            DT_NSO_2001_010V1
    ## 665             DT_NSO_2001_010V2.px            DT_NSO_2001_010V2
    ## 666             DT_NSO_2001_011V1.px            DT_NSO_2001_011V1
    ## 667             DT_NSO_2001_011V3.px            DT_NSO_2001_011V3
    ## 668             DT_NSO_2001_012V1.px            DT_NSO_2001_012V1
    ## 669             DT_NSO_2001_013V1.px            DT_NSO_2001_013V1
    ## 670             DT_NSO_2001_019V1.px            DT_NSO_2001_019V1
    ## 671             DT_NSO_2001_020V1.px            DT_NSO_2001_020V1
    ## 672             DT_NSO_2001_023V2.px            DT_NSO_2001_023V2
    ## 673             DT_NSO_2002_014V1.px            DT_NSO_2002_014V1
    ## 674             DT_NSO_2002_026V1.px            DT_NSO_2002_026V1
    ## 675             DT_NSO_2002_056V1.px            DT_NSO_2002_056V1
    ## 676             DT_NSO_2002_057V1.px            DT_NSO_2002_057V1
    ## 677             DT_NSO_2002_057V2.px            DT_NSO_2002_057V2
    ## 678             DT_NSO_2002_057V3.px            DT_NSO_2002_057V3
    ## 679             DT_NSO_2002_058V1.px            DT_NSO_2002_058V1
    ## 680             DT_NSO_2002_058V2.px            DT_NSO_2002_058V2
    ## 681             DT_NSO_2002_058V4.px            DT_NSO_2002_058V4
    ## 682             DT_NSO_0100_001D1.px            DT_NSO_0100_001D1
    ## 683             DT_NSO_0100_001D2.px            DT_NSO_0100_001D2
    ## 684             DT_NSO_0400_081V7.px            DT_NSO_0400_081V7
    ## 685             DT_NSO_0400_081V8.px            DT_NSO_0400_081V8
    ## 686  DT_NSO_0800_011V1_Buschilsen.px DT_NSO_0800_011V1_Buschilsen
    ## 687  DT_NSO_0800_029V1_Buschilsen.px DT_NSO_0800_029V1_Buschilsen
    ## 688  DT_NSO_0800_031V1_Buschilsen.px DT_NSO_0800_031V1_Buschilsen
    ## 689             DT_NSO_2700_001V1.px            DT_NSO_2700_001V1
    ## 690             DT_NSO_2700_002V1.px            DT_NSO_2700_002V1
    ## 691             DT_NSO_2700_002V2.px            DT_NSO_2700_002V2
    ## 692             DT_NSO_2700_004V1.px            DT_NSO_2700_004V1
    ## 693             DT_NSO_2700_005V1.px            DT_NSO_2700_005V1
    ## 694             DT_NSO_1700_001V2.px            DT_NSO_1700_001V2
    ## 695             DT_NSO_3500_001V1.px            DT_NSO_3500_001V1
    ## 696             DT_NSO_3500_002V1.px            DT_NSO_3500_002V1
    ## 697             DT_NSO_3500_003V1.px            DT_NSO_3500_003V1
    ## 698             DT_NSO_3500_005V1.px            DT_NSO_3500_005V1
    ## 699             DT_NSO_3500_006V1.px            DT_NSO_3500_006V1
    ## 700             DT_NSO_1500_015V3.px            DT_NSO_1500_015V3
    ## 701            DT_NSO_2300_001A_1.px           DT_NSO_2300_001A_1
    ## 702             DT_NSO_2300_001A1.px            DT_NSO_2300_001A1
    ## 703             DT_NSO_2300_001A2.px            DT_NSO_2300_001A2
    ## 704             DT_NSO_2300_003V1.px            DT_NSO_2300_003V1
    ## 705            DT_NSO_2300_004V_1.px           DT_NSO_2300_004V_1
    ## 706             DT_NSO_2300_004V1.px            DT_NSO_2300_004V1
    ## 707             DT_NSO_2300_014V1.px            DT_NSO_2300_014V1
    ## 708             DT_NSO_2300_015V2.px            DT_NSO_2300_015V2
    ## 709             DT_NSO_2300_016V1.px            DT_NSO_2300_016V1
    ## 710             DT_NSO_2300_017V1.px            DT_NSO_2300_017V1
    ## 711             DT_NSO_2300_018V1.px            DT_NSO_2300_018V1
    ## 712             DT_NSO_2300_021V1.px            DT_NSO_2300_021V1
    ## 713             DT_NSO_2300_022V1.px            DT_NSO_2300_022V1
    ## 714             DT_NSO_2300_023V1.px            DT_NSO_2300_023V1
    ## 715             DT_NSO_2300_024V1.px            DT_NSO_2300_024V1
    ## 716             DT_NSO_2300_025V1.px            DT_NSO_2300_025V1
    ## 717             DT_NSO_2300_026V1.px            DT_NSO_2300_026V1
    ## 718             DT_NSO_2300_027V1.px            DT_NSO_2300_027V1
    ## 719             DT_NSO_2300_037V1.px            DT_NSO_2300_037V1
    ## 720             DT_NSO_2300_039V1.px            DT_NSO_2300_039V1
    ## 721             DT_NSO_2300_044V1.px            DT_NSO_2300_044V1
    ## 722             DT_NSO_2300_045V1.px            DT_NSO_2300_045V1
    ## 723              DT_NSO_2300_10V1.px             DT_NSO_2300_10V1
    ## 724             DT_NSO_1001_108V1.px            DT_NSO_1001_108V1
    ## 725             DT_NSO_1001_109V1.px            DT_NSO_1001_109V1
    ## 726             DT_NSO_1001_110V2.px            DT_NSO_1001_110V2
    ## 727             DT_NSO_1001_120V1.px            DT_NSO_1001_120V1
    ## 728             DT_NSO_1001_120V2.px            DT_NSO_1001_120V2
    ## 729             DT_NSO_1001_130V2.px            DT_NSO_1001_130V2
    ## 730             DT_NSO_1001_131V1.px            DT_NSO_1001_131V1
    ## 731             DT_NSO_1001_132V1.px            DT_NSO_1001_132V1
    ## 732             DT_NSO_1001_133V1.px            DT_NSO_1001_133V1
    ## 733             DT_NSO_1001_134V1.px            DT_NSO_1001_134V1
    ## 734             DT_NSO_1001_135V1.px            DT_NSO_1001_135V1
    ## 735             DT_NSO_1001_136V1.px            DT_NSO_1001_136V1
    ## 736             DT_NSO_2003_001V1.px            DT_NSO_2003_001V1
    ## 737             DT_NSO_2003_002V1.px            DT_NSO_2003_002V1
    ## 738             DT_NSO_2003_003V1.px            DT_NSO_2003_003V1
    ## 739             DT_NSO_0700_005V1.px            DT_NSO_0700_005V1
    ## 740             DT_NSO_0700_006V1.px            DT_NSO_0700_006V1
    ## 741             DT_NSO_0700_007V1.px            DT_NSO_0700_007V1
    ## 742         DT_NSO_0500_007V1 (2).px        DT_NSO_0500_007V1 (2)
    ## 743             DT_NSO_0500_011V1.px            DT_NSO_0500_011V1
    ## 744            DT_NSO_0500_020V22.px           DT_NSO_0500_020V22
    ## 745             DT_NSO_0500_021V1.px            DT_NSO_0500_021V1
    ## 746             DT_NSO_0500_021V2.px            DT_NSO_0500_021V2
    ## 747             DT_NSO_0901_004V1.px            DT_NSO_0901_004V1
    ## 748             DT_NSO_0901_005V1.px            DT_NSO_0901_005V1
    ## 749             DT_NSO_0300_002V4.px            DT_NSO_0300_002V4
    ## 750             DT_NSO_0300_004V1.px            DT_NSO_0300_004V1
    ## 751             DT_NSO_0300_004V5.px            DT_NSO_0300_004V5
    ## 752             DT_NSO_0300_006V2.px            DT_NSO_0300_006V2
    ## 753             DT_NSO_0300_006V5.px            DT_NSO_0300_006V5
    ## 754             DT_NSO_0300_013V4.px            DT_NSO_0300_013V4
    ## 755             DT_NSO_0300_013V6.px            DT_NSO_0300_013V6
    ## 756             DT_NSO_0300_016V3.px            DT_NSO_0300_016V3
    ## 757             DT_NSO_0300_018V2.px            DT_NSO_0300_018V2
    ## 758             DT_NSO_0300_019V6.px            DT_NSO_0300_019V6
    ## 759             DT_NSO_0300_020V1.px            DT_NSO_0300_020V1
    ## 760             DT_NSO_0300_023V4.px            DT_NSO_0300_023V4
    ## 761             DT_NSO_0300_024V2.px            DT_NSO_0300_024V2
    ## 762             DT_NSO_0300_029V3.px            DT_NSO_0300_029V3
    ## 763             DT_NSO_0300_030V1.px            DT_NSO_0300_030V1
    ## 764             DT_NSO_0300_032V3.px            DT_NSO_0300_032V3
    ## 765             DT_NSO_0300_034V2.px            DT_NSO_0300_034V2
    ## 766             DT_NSO_0300_035V2.px            DT_NSO_0300_035V2
    ## 767             DT_NSO_0300_038V4.px            DT_NSO_0300_038V4
    ## 768             DT_NSO_0300_040V1.px            DT_NSO_0300_040V1
    ## 769             DT_NSO_0300_051V3.px            DT_NSO_0300_051V3
    ## 770             DT_NSO_0300_052V2.px            DT_NSO_0300_052V2
    ## 771             DT_NSO_0300_067V2.px            DT_NSO_0300_067V2
    ## 772             DT_NSO_0300_068V2.px            DT_NSO_0300_068V2
    ## 773             DT_NSO_1900_001V3.px            DT_NSO_1900_001V3
    ## 774             DT_NSO_1900_002V3.px            DT_NSO_1900_002V3
    ## 775             DT_NSO_1900_003V3.px            DT_NSO_1900_003V3
    ## 776             DT_NSO_1900_004V3.px            DT_NSO_1900_004V3
    ## 777             DT_NSO_1900_036V4.px            DT_NSO_1900_036V4
    ## 778             DT_NSO_0303_07V71.px            DT_NSO_0303_07V71
    ## 779             DT_NSO_0303_07V81.px            DT_NSO_0303_07V81
    ## 780             DT_NSO_0303_07V91.px            DT_NSO_0303_07V91
    ## 781             DT_NSO_0600_001V3.px            DT_NSO_0600_001V3
    ## 782             DT_NSO_0600_002V1.px            DT_NSO_0600_002V1
    ## 783             DT_NSO_0600_008V1.px            DT_NSO_0600_008V1
    ## 784             DT_NSO_0600_009V1.px            DT_NSO_0600_009V1
    ## 785             DT_NSO_0600_010V1.px            DT_NSO_0600_010V1
    ## 786             DT_NSO_0600_013V2.px            DT_NSO_0600_013V2
    ## 787             DT_NSO_0500_001V9.px            DT_NSO_0500_001V9
    ## 788             DT_NSO_BR_01V11_1.px            DT_NSO_BR_01V11_1
    ## 789           DT_NSO_2600_001V5_2.px          DT_NSO_2600_001V5_2
    ## 790           DT_NSO_2600_001V5_3.px          DT_NSO_2600_001V5_3
    ## 791           DT_NSO_2600_005V2_1.px          DT_NSO_2600_005V2_1
    ## 792           DT_NSO_2600_010V2_1.px          DT_NSO_2600_010V2_1
    ## 793           DT_NSO_2600_011V1_1.px          DT_NSO_2600_011V1_1
    ## 794           DT_NSO_2600_011V3_1.px          DT_NSO_2600_011V3_1
    ## 795           DT_NSO_2600_017V1_1.px          DT_NSO_2600_017V1_1
    ## 796             DT_NSO_0100_001V1.px            DT_NSO_0100_001V1
    ## 797       DT_NSO_1600_002V1_month.px      DT_NSO_1600_002V1_month
    ## 798        DT_NSO_1600_002V1_year.px       DT_NSO_1600_002V1_year
    ## 799             DT_NSO_1602_003V1.px            DT_NSO_1602_003V1
    ## 800           DT_NSO_1602_003V1_1.px          DT_NSO_1602_003V1_1
    ## 801             DT_NSO_1602_004V1.px            DT_NSO_1602_004V1
    ## 802           DT_NSO_1602_004V1_1.px          DT_NSO_1602_004V1_1
    ## 803           DT_NSO_1200_012V1_q.px          DT_NSO_1200_012V1_q
    ## 804             DT_NSO_1200_012V4.px            DT_NSO_1200_012V4
    ## 805           DT_NSO_1200_012V5_m.px          DT_NSO_1200_012V5_m
    ## 806           DT_NSO_1200_012V6_m.px          DT_NSO_1200_012V6_m
    ## 807           DT_NSO_1200_012V7_m.px          DT_NSO_1200_012V7_m
    ## 808             DT_NSO_1200_013V1.px            DT_NSO_1200_013V1
    ## 809             DT_NSO_1200_013V2.px            DT_NSO_1200_013V2
    ## 810             DT_NSO_1200_013V3.px            DT_NSO_1200_013V3
    ## 811             DT_NSO_1200_013V4.px            DT_NSO_1200_013V4
    ## 812             DT_NSO_1200_013V5.px            DT_NSO_1200_013V5
    ## 813           DT_NSO_1300_011V1_q.px          DT_NSO_1300_011V1_q
    ## 814           DT_NSO_1300_012V1_q.px          DT_NSO_1300_012V1_q
    ## 815           DT_NSO_1300_013V1_q.px          DT_NSO_1300_013V1_q
    ## 816           DT_NSO_1300_014V1_q.px          DT_NSO_1300_014V1_q
    ## 817           DT_NSO_1300_015V1_q.px          DT_NSO_1300_015V1_q
    ## 818             DT_NSO_3900_002V1.px            DT_NSO_3900_002V1
    ## 819             DT_NSO_3900_004V1.px            DT_NSO_3900_004V1
    ## 820             DT_NSO_3900_004V2.px            DT_NSO_3900_004V2
    ## 821             DT_NSO_3900_004V3.px            DT_NSO_3900_004V3
    ## 822             DT_NSO_3900_004V4.px            DT_NSO_3900_004V4
    ## 823             DT_NSO_3900_004V5.px            DT_NSO_3900_004V5
    ## 824             DT_NSO_3900_004V6.px            DT_NSO_3900_004V6
    ## 825             DT_NSO_3900_004V7.px            DT_NSO_3900_004V7
    ## 826             DT_NSO_3900_004V8.px            DT_NSO_3900_004V8
    ## 827             DT_NSO_0200_001V1.px            DT_NSO_0200_001V1
    ## 828             DT_NSO_0200_002V1.px            DT_NSO_0200_002V1
    ## 829             DT_NSO_0200_003V1.px            DT_NSO_0200_003V1
    ## 830             DT_NSO_0200_004V1.px            DT_NSO_0200_004V1
    ## 831             DT_NSO_0200_005V1.px            DT_NSO_0200_005V1
    ## 832             DT_NSO_1003_001V1.px            DT_NSO_1003_001V1
    ## 833             DT_NSO_1003_002V1.px            DT_NSO_1003_002V1
    ## 834             DT_NSO_1003_003V1.px            DT_NSO_1003_003V1
    ## 835             DT_NSO_1003_004V1.px            DT_NSO_1003_004V1
    ## 836             DT_NSO_1003_005V1.px            DT_NSO_1003_005V1
    ## 837             DT_NSO_1003_006V1.px            DT_NSO_1003_006V1
    ## 838              DT_NSO_2300_20V1.px             DT_NSO_2300_20V1
    ## 839              DT_NSO_2300_22V1.px             DT_NSO_2300_22V1
    ## 840             DT_NSO_0100_001D1.px            DT_NSO_0100_001D1
    ## 841             DT_NSO_0100_001D2.px            DT_NSO_0100_001D2
    ## 842             DT_NSO_0400_081V7.px            DT_NSO_0400_081V7
    ## 843             DT_NSO_0400_081V8.px            DT_NSO_0400_081V8
    ## 844             DT_NSO_3800_001V1.px            DT_NSO_3800_001V1
    ## 845             DT_NSO_3800_001V2.px            DT_NSO_3800_001V2
    ## 846             DT_NSO_3800_002V1.px            DT_NSO_3800_002V1
    ## 847             DT_NSO_3800_002V2.px            DT_NSO_3800_002V2
    ## 848             DT_NSO_3800_002V3.px            DT_NSO_3800_002V3
    ## 849             DT_NSO_3800_003V1.px            DT_NSO_3800_003V1
    ## 850             DT_NSO_3800_003V2.px            DT_NSO_3800_003V2
    ## 851             DT_NSO_3800_003V3.px            DT_NSO_3800_003V3
    ## 852             DT_NSO_3800_004V1.px            DT_NSO_3800_004V1
    ## 853             DT_NSO_3800_004V2.px            DT_NSO_3800_004V2
    ## 854             DT_NSO_3800_004V3.px            DT_NSO_3800_004V3
    ## 855             DT_NSO_3800_004V4.px            DT_NSO_3800_004V4
    ## 856             DT_NSO_3800_004V5.px            DT_NSO_3800_004V5
    ## 857             DT_NSO_3800_005V1.px            DT_NSO_3800_005V1
    ## 858             DT_NSO_3800_005V2.px            DT_NSO_3800_005V2
    ## 859             DT_NSO_3800_005V3.px            DT_NSO_3800_005V3
    ## 860             DT_NSO_3800_006V1.px            DT_NSO_3800_006V1
    ## 861             DT_NSO_3800_006V2.px            DT_NSO_3800_006V2
    ## 862             DT_NSO_3800_007V1.px            DT_NSO_3800_007V1
    ## 863             DT_NSO_3800_007V2.px            DT_NSO_3800_007V2
    ## 864             DT_NSO_3800_007V3.px            DT_NSO_3800_007V3
    ## 865             DT_NSO_3800_008V1.px            DT_NSO_3800_008V1
    ## 866             DT_NSO_3800_008V2.px            DT_NSO_3800_008V2
    ## 867             DT_NSO_1900_001V1.px            DT_NSO_1900_001V1
    ## 868             DT_NSO_1900_001V2.px            DT_NSO_1900_001V2
    ## 869             DT_NSO_1900_002V1.px            DT_NSO_1900_002V1
    ## 870             DT_NSO_1900_002V2.px            DT_NSO_1900_002V2
    ## 871             DT_NSO_1900_003V1.px            DT_NSO_1900_003V1
    ## 872             DT_NSO_1900_003V2.px            DT_NSO_1900_003V2
    ## 873             DT_NSO_1900_004V1.px            DT_NSO_1900_004V1
    ## 874             DT_NSO_1900_004V2.px            DT_NSO_1900_004V2
    ## 875             DT_NSO_1900_005V1.px            DT_NSO_1900_005V1
    ## 876             DT_NSO_1900_006V1.px            DT_NSO_1900_006V1
    ## 877             DT_NSO_1900_015V1.px            DT_NSO_1900_015V1
    ## 878             DT_NSO_1900_017V1.px            DT_NSO_1900_017V1
    ## 879             DT_NSO_1900_018V1.px            DT_NSO_1900_018V1
    ## 880             DT_NSO_1900_019V1.px            DT_NSO_1900_019V1
    ## 881             DT_NSO_1900_020V1.px            DT_NSO_1900_020V1
    ## 882             DT_NSO_1900_021V1.px            DT_NSO_1900_021V1
    ## 883             DT_NSO_1900_030V2.px            DT_NSO_1900_030V2
    ## 884             DT_NSO_1900_032V1.px            DT_NSO_1900_032V1
    ## 885             DT_NSO_1900_033V1.px            DT_NSO_1900_033V1
    ## 886             DT_NSO_1900_036V2.px            DT_NSO_1900_036V2
    ## 887             DT_NSO_1900_036V3.px            DT_NSO_1900_036V3
    ## 888             DT_NSO_2700_001V1.px            DT_NSO_2700_001V1
    ## 889             DT_NSO_2700_001V2.px            DT_NSO_2700_001V2
    ## 890             DT_NSO_2700_002V1.px            DT_NSO_2700_002V1
    ## 891             DT_NSO_2700_002V2.px            DT_NSO_2700_002V2
    ## 892             DT_NSO_2700_003V1.px            DT_NSO_2700_003V1
    ## 893             DT_NSO_2700_004V1.px            DT_NSO_2700_004V1
    ## 894             DT_NSO_2700_005V1.px            DT_NSO_2700_005V1
    ## 895             DT_NSO_1500_015V3.px            DT_NSO_1500_015V3
    ## 896             DT_NSO_2300_001A2.px            DT_NSO_2300_001A2
    ## 897             DT_NSO_2300_001A3.px            DT_NSO_2300_001A3
    ## 898             DT_NSO_2300_001A4.px            DT_NSO_2300_001A4
    ## 899           DT_NSO_2300_008V101.px          DT_NSO_2300_008V101
    ## 900             DT_NSO_2300_009V1.px            DT_NSO_2300_009V1
    ## 901             DT_NSO_2300_011V1.px            DT_NSO_2300_011V1
    ## 902             DT_NSO_2300_012V1.px            DT_NSO_2300_012V1
    ## 903             DT_NSO_2300_014V1.px            DT_NSO_2300_014V1
    ## 904             DT_NSO_2300_015V2.px            DT_NSO_2300_015V2
    ## 905             DT_NSO_2300_016V1.px            DT_NSO_2300_016V1
    ## 906             DT_NSO_2300_017V1.px            DT_NSO_2300_017V1
    ## 907             DT_NSO_2300_018V1.px            DT_NSO_2300_018V1
    ## 908             DT_NSO_2300_021V1.px            DT_NSO_2300_021V1
    ## 909             DT_NSO_2300_022V1.px            DT_NSO_2300_022V1
    ## 910             DT_NSO_2300_023V1.px            DT_NSO_2300_023V1
    ## 911             DT_NSO_2300_024V1.px            DT_NSO_2300_024V1
    ## 912             DT_NSO_2300_025V1.px            DT_NSO_2300_025V1
    ## 913             DT_NSO_2300_026V1.px            DT_NSO_2300_026V1
    ## 914             DT_NSO_2300_027V1.px            DT_NSO_2300_027V1
    ## 915             DT_NSO_2300_031V1.px            DT_NSO_2300_031V1
    ## 916             DT_NSO_2300_032V1.px            DT_NSO_2300_032V1
    ## 917             DT_NSO_2300_033V1.px            DT_NSO_2300_033V1
    ## 918             DT_NSO_2300_034V1.px            DT_NSO_2300_034V1
    ## 919           DT_NSO_2300_035V201.px          DT_NSO_2300_035V201
    ## 920             DT_NSO_2300_036V1.px            DT_NSO_2300_036V1
    ## 921             DT_NSO_2300_037V1.px            DT_NSO_2300_037V1
    ## 922             DT_NSO_2300_037V2.px            DT_NSO_2300_037V2
    ## 923            DT_NSO_2300_037V21.px           DT_NSO_2300_037V21
    ## 924             DT_NSO_2300_037V3.px            DT_NSO_2300_037V3
    ## 925             DT_NSO_2300_037V4.px            DT_NSO_2300_037V4
    ## 926             DT_NSO_2300_037V5.px            DT_NSO_2300_037V5
    ## 927             DT_NSO_2300_038V1.px            DT_NSO_2300_038V1
    ## 928             DT_NSO_2300_039V1.px            DT_NSO_2300_039V1
    ## 929             DT_NSO_2300_039V2.px            DT_NSO_2300_039V2
    ## 930             DT_NSO_2300_039V3.px            DT_NSO_2300_039V3
    ## 931             DT_NSO_2300_040V1.px            DT_NSO_2300_040V1
    ## 932             DT_NSO_2300_041V1.px            DT_NSO_2300_041V1
    ## 933             DT_NSO_2300_042V1.px            DT_NSO_2300_042V1
    ## 934             DT_NSO_2300_043V1.px            DT_NSO_2300_043V1
    ## 935             DT_NSO_2300_044V1.px            DT_NSO_2300_044V1
    ## 936             DT_NSO_2300_045V1.px            DT_NSO_2300_045V1
    ## 937             DT_NSO_2300_046V1.px            DT_NSO_2300_046V1
    ## 938              DT_NSO_2300_10V1.px             DT_NSO_2300_10V1
    ## 939             DT_NSO_2800_001V1.px            DT_NSO_2800_001V1
    ## 940             DT_NSO_2800_002V1.px            DT_NSO_2800_002V1
    ## 941             DT_NSO_2800_003V1.px            DT_NSO_2800_003V1
    ## 942             DT_NSO_2800_004V1.px            DT_NSO_2800_004V1
    ## 943             DT_NSO_2800_005V1.px            DT_NSO_2800_005V1
    ## 944             DT_NSO_2800_006V1.px            DT_NSO_2800_006V1
    ## 945             DT_NSO_2800_007V1.px            DT_NSO_2800_007V1
    ## 946             DT_NSO_2800_008V1.px            DT_NSO_2800_008V1
    ## 947             DT_NSO_2800_009V1.px            DT_NSO_2800_009V1
    ## 948             DT_NSO_2800_010V1.px            DT_NSO_2800_010V1
    ## 949             DT_NSO_2800_011V1.px            DT_NSO_2800_011V1
    ## 950             DT_NSO_2800_012V1.px            DT_NSO_2800_012V1
    ## 951             DT_NSO_2800_013V1.px            DT_NSO_2800_013V1
    ## 952             DT_NSO_2800_014V1.px            DT_NSO_2800_014V1
    ## 953             DT_NSO_2800_015V1.px            DT_NSO_2800_015V1
    ## 954             DT_NSO_2800_016V1.px            DT_NSO_2800_016V1
    ## 955             DT_NSO_2800_017V1.px            DT_NSO_2800_017V1
    ## 956             DT_NSO_2800_018V1.px            DT_NSO_2800_018V1
    ## 957             DT_NSO_2800_019V1.px            DT_NSO_2800_019V1
    ## 958             DT_NSO_2800_020V1.px            DT_NSO_2800_020V1
    ## 959             DT_NSO_2800_021V1.px            DT_NSO_2800_021V1
    ## 960             DT_NSO_2800_022V1.px            DT_NSO_2800_022V1
    ## 961             DT_NSO_2800_023V1.px            DT_NSO_2800_023V1
    ## 962             DT_NSO_2800_024V1.px            DT_NSO_2800_024V1
    ## 963             DT_NSO_2800_025V1.px            DT_NSO_2800_025V1
    ## 964             DT_NSO_2800_026V1.px            DT_NSO_2800_026V1
    ## 965             DT_NSO_2800_027V1.px            DT_NSO_2800_027V1
    ## 966             DT_NSO_2800_028V1.px            DT_NSO_2800_028V1
    ## 967             DT_NSO_2800_029V1.px            DT_NSO_2800_029V1
    ## 968             DT_NSO_2800_030V1.px            DT_NSO_2800_030V1
    ## 969             DT_NSO_2800_031V1.px            DT_NSO_2800_031V1
    ## 970             DT_NSO_2800_032V1.px            DT_NSO_2800_032V1
    ## 971             DT_NSO_2800_033V1.px            DT_NSO_2800_033V1
    ## 972             DT_NSO_2800_034V1.px            DT_NSO_2800_034V1
    ## 973             DT_NSO_2800_035V1.px            DT_NSO_2800_035V1
    ## 974             DT_NSO_2800_036V1.px            DT_NSO_2800_036V1
    ## 975             DT_NSO_2800_037V1.px            DT_NSO_2800_037V1
    ## 976             DT_NSO_2800_038V1.px            DT_NSO_2800_038V1
    ## 977             DT_NSO_2800_039V1.px            DT_NSO_2800_039V1
    ## 978             DT_NSO_2800_040V1.px            DT_NSO_2800_040V1
    ## 979             DT_NSO_2800_041V1.px            DT_NSO_2800_041V1
    ## 980             DT_NSO_2800_042V1.px            DT_NSO_2800_042V1
    ## 981             DT_NSO_2800_043V1.px            DT_NSO_2800_043V1
    ## 982             DT_NSO_2800_044V1.px            DT_NSO_2800_044V1
    ## 983             DT_NSO_2800_045V1.px            DT_NSO_2800_045V1
    ## 984             DT_NSO_2800_046V1.px            DT_NSO_2800_046V1
    ## 985             DT_NSO_2800_047V1.px            DT_NSO_2800_047V1
    ## 986             DT_NSO_2800_048V1.px            DT_NSO_2800_048V1
    ## 987             DT_NSO_2800_049V1.px            DT_NSO_2800_049V1
    ## 988             DT_NSO_2800_050V1.px            DT_NSO_2800_050V1
    ## 989             DT_NSO_2800_051V1.px            DT_NSO_2800_051V1
    ## 990             DT_NSO_2800_052V1.px            DT_NSO_2800_052V1
    ## 991             DT_NSO_2800_053V1.px            DT_NSO_2800_053V1
    ## 992             DT_NSO_2800_054V1.px            DT_NSO_2800_054V1
    ## 993             DT_NSO_2800_055V1.px            DT_NSO_2800_055V1
    ## 994             DT_NSO_2800_056V1.px            DT_NSO_2800_056V1
    ## 995             DT_NSO_2800_057V1.px            DT_NSO_2800_057V1
    ## 996             DT_NSO_2800_058V1.px            DT_NSO_2800_058V1
    ## 997             DT_NSO_2800_059V1.px            DT_NSO_2800_059V1
    ## 998             DT_NSO_2800_060V1.px            DT_NSO_2800_060V1
    ## 999             DT_NSO_2800_061V1.px            DT_NSO_2800_061V1
    ## 1000            DT_NSO_2800_061V2.px            DT_NSO_2800_061V2
    ## 1001            DT_NSO_2800_062V1.px            DT_NSO_2800_062V1
    ## 1002            DT_NSO_2800_063V1.px            DT_NSO_2800_063V1
    ## 1003            DT_NSO_2800_064V1.px            DT_NSO_2800_064V1
    ## 1004            DT_NSO_2800_065V1.px            DT_NSO_2800_065V1
    ## 1005            DT_NSO_2800_066V1.px            DT_NSO_2800_066V1
    ## 1006            DT_NSO_2800_067V1.px            DT_NSO_2800_067V1
    ## 1007            DT_NSO_2800_068V1.px            DT_NSO_2800_068V1
    ## 1008            DT_NSO_2800_069V1.px            DT_NSO_2800_069V1
    ## 1009            DT_NSO_2800_070V1.px            DT_NSO_2800_070V1
    ## 1010            DT_NSO_2800_071V1.px            DT_NSO_2800_071V1
    ## 1011            DT_NSO_2800_072V1.px            DT_NSO_2800_072V1
    ## 1012            DT_NSO_2800_073V1.px            DT_NSO_2800_073V1
    ## 1013            DT_NSO_2800_074V1.px            DT_NSO_2800_074V1
    ## 1014            DT_NSO_2800_075V1.px            DT_NSO_2800_075V1
    ## 1015            DT_NSO_2800_076V1.px            DT_NSO_2800_076V1
    ## 1016            DT_NSO_2800_077V1.px            DT_NSO_2800_077V1
    ## 1017            DT_NSO_2800_078V1.px            DT_NSO_2800_078V1
    ## 1018            DT_NSO_2800_079V1.px            DT_NSO_2800_079V1
    ## 1019            DT_NSO_2800_080V1.px            DT_NSO_2800_080V1
    ## 1020            DT_NSO_2003_001V1.px            DT_NSO_2003_001V1
    ## 1021            DT_NSO_2003_002V1.px            DT_NSO_2003_002V1
    ## 1022            DT_NSO_2003_003V1.px            DT_NSO_2003_003V1
    ## 1023            DT_NSO_1900_007V1.px            DT_NSO_1900_007V1
    ## 1024           DT_NSO_1900_007V12.px           DT_NSO_1900_007V12
    ## 1025            DT_NSO_1900_008V1.px            DT_NSO_1900_008V1
    ## 1026            DT_NSO_1900_010V1.px            DT_NSO_1900_010V1
    ## 1027            DT_NSO_1900_011V1.px            DT_NSO_1900_011V1
    ## 1028            DT_NSO_1900_013V1.px            DT_NSO_1900_013V1
    ## 1029            DT_NSO_1900_014V1.px            DT_NSO_1900_014V1
    ## 1030            DT_NSO_1900_016V1.px            DT_NSO_1900_016V1
    ## 1031            DT_NSO_1900_022V1.px            DT_NSO_1900_022V1
    ## 1032            DT_NSO_1900_035V1.px            DT_NSO_1900_035V1
    ## 1033            DT_NSO_1900_036V1.px            DT_NSO_1900_036V1
    ## 1034               DT_NSO_2025_01.px               DT_NSO_2025_01
    ## 1035               DT_NSO_2025_02.px               DT_NSO_2025_02
    ## 1036               DT_NSO_2025_03.px               DT_NSO_2025_03
    ## 1037               DT_NSO_2025_04.px               DT_NSO_2025_04
    ## 1038               DT_NSO_2025_05.px               DT_NSO_2025_05
    ## 1039               DT_NSO_2025_06.px               DT_NSO_2025_06
    ## 1040               DT_NSO_2025_07.px               DT_NSO_2025_07
    ## 1041               DT_NSO_2025_08.px               DT_NSO_2025_08
    ## 1042               DT_NSO_2025_09.px               DT_NSO_2025_09
    ## 1043               DT_NSO_2025_10.px               DT_NSO_2025_10
    ## 1044               DT_NSO_2025_11.px               DT_NSO_2025_11
    ## 1045               DT_NSO_2025_12.px               DT_NSO_2025_12
    ## 1046               DT_NSO_2025_13.px               DT_NSO_2025_13
    ## 1047               DT_NSO_2025_14.px               DT_NSO_2025_14
    ## 1048               DT_NSO_2025_15.px               DT_NSO_2025_15
    ## 1049               DT_NSO_2025_16.px               DT_NSO_2025_16
    ## 1050               DT_NSO_2025_17.px               DT_NSO_2025_17
    ## 1051               DT_NSO_2025_18.px               DT_NSO_2025_18
    ## 1052               DT_NSO_2025_19.px               DT_NSO_2025_19
    ## 1053               DT_NSO_2025_21.px               DT_NSO_2025_21
    ## 1054               DT_NSO_2025_22.px               DT_NSO_2025_22
    ## 1055               DT_NSO_2025_23.px               DT_NSO_2025_23
    ## 1056               DT_NSO_2025_24.px               DT_NSO_2025_24
    ## 1057               DT_NSO_2025_25.px               DT_NSO_2025_25
    ## 1058             DT_NSO_2100_30V5.px             DT_NSO_2100_30V5
    ## 1059             DT_NSO_2100_30V6.px             DT_NSO_2100_30V6
    ## 1060              DT_NSO_4000_001.px              DT_NSO_4000_001
    ## 1061            DT_NSO_0700_025V1.px            DT_NSO_0700_025V1
    ## 1062            DT_NSO_0700_025V2.px            DT_NSO_0700_025V2
    ## 1063            DT_NSO_0700_025V3.px            DT_NSO_0700_025V3
    ## 1064            DT_NSO_0700_025V4.px            DT_NSO_0700_025V4
    ## 1065            DT_NSO_0700_025V5.px            DT_NSO_0700_025V5
    ## 1066          DT_NSO_1100_016V4_1.px          DT_NSO_1100_016V4_1
    ## 1067          DT_NSO_1100_016V4_2.px          DT_NSO_1100_016V4_2
    ## 1068          DT_NSO_1100_015V4_1.px          DT_NSO_1100_015V4_1
    ## 1069          DT_NSO_1100_015V4_2.px          DT_NSO_1100_015V4_2
    ## 1070          DT_NSO_1100_015V4_3.px          DT_NSO_1100_015V4_3
    ## 1071          DT_NSO_1100_015V6_1.px          DT_NSO_1100_015V6_1
    ## 1072          DT_NSO_1100_015V6_2.px          DT_NSO_1100_015V6_2
    ## 1073          DT_NSO_1100_015V6_3.px          DT_NSO_1100_015V6_3
    ## 1074          DT_NSO_1100_015V5_1.px          DT_NSO_1100_015V5_1
    ## 1075          DT_NSO_1100_015V5_2.px          DT_NSO_1100_015V5_2
    ## 1076          DT_NSO_1100_015V5_3.px          DT_NSO_1100_015V5_3
    ## 1077          DT_NSO_1100_015V7_1.px          DT_NSO_1100_015V7_1
    ## 1078          DT_NSO_1100_015V7_2.px          DT_NSO_1100_015V7_2
    ## 1079          DT_NSO_1100_015V7_3.px          DT_NSO_1100_015V7_3
    ## 1080            DT_NSO_2100_002V1.px            DT_NSO_2100_002V1
    ## 1081            DT_NSO_2100_002V2.px            DT_NSO_2100_002V2
    ## 1082            DT_NSO_2100_004V1.px            DT_NSO_2100_004V1
    ## 1083            DT_NSO_2100_004V4.px            DT_NSO_2100_004V4
    ## 1084            DT_NSO_0902_008V1.px            DT_NSO_0902_008V1
    ## 1085            DT_NSO_0902_008V2.px            DT_NSO_0902_008V2
    ## 1086            DT_NSO_2002_054V7.px            DT_NSO_2002_054V7
    ## 1087          DT_NSO_2002_054V7_1.px          DT_NSO_2002_054V7_1
    ## 1088            DT_NSO_2002_054V4.px            DT_NSO_2002_054V4
    ## 1089          DT_NSO_2002_054V4_1.px          DT_NSO_2002_054V4_1
    ## 1090            DT_NSO_2002_054V3.px            DT_NSO_2002_054V3
    ## 1091          DT_NSO_2002_054V3_1.px          DT_NSO_2002_054V3_1
    ## 1092            DT_NSO_2002_054V1.px            DT_NSO_2002_054V1
    ## 1093          DT_NSO_2002_054V1_1.px          DT_NSO_2002_054V1_1
    ## 1094            DT_NSO_2001_035V1.px            DT_NSO_2001_035V1
    ## 1095          DT_NSO_2001_035V1_1.px          DT_NSO_2001_035V1_1
    ## 1096          DT_NSO_2001_035V3_1.px          DT_NSO_2001_035V3_1
    ## 1097            DT_NSO_2002_054V5.px            DT_NSO_2002_054V5
    ## 1098          DT_NSO_2002_054V5_1.px          DT_NSO_2002_054V5_1
    ## 1099            DT_NSO_2002_054V8.px            DT_NSO_2002_054V8
    ## 1100          DT_NSO_2002_054V8_1.px          DT_NSO_2002_054V8_1
    ## 1101            DT_NSO_2002_054V6.px            DT_NSO_2002_054V6
    ## 1102          DT_NSO_2002_054V6_1.px          DT_NSO_2002_054V6_1
    ## 1103            DT_NSO_2002_054V2.px            DT_NSO_2002_054V2
    ## 1104          DT_NSO_2002_054V2-1.px          DT_NSO_2002_054V2-1
    ## 1105            DT_NSO_2001_035V3.px            DT_NSO_2001_035V3
    ## 1106          DT_NSO_2001_035V3_1.px          DT_NSO_2001_035V3_1
    ## 1107            DT_NSO_2002_054V9.px            DT_NSO_2002_054V9
    ## 1108          DT_NSO_2002_054V9_1.px          DT_NSO_2002_054V9_1
    ## 1109            DT_NSO_2001_035V2.px            DT_NSO_2001_035V2
    ## 1110          DT_NSO_2001_035V2_1.px          DT_NSO_2001_035V2_1
    ## 1111          DT_NSO_1300_013V1_q.px          DT_NSO_1300_013V1_q
    ## 1112          DT_NSO_1300_013V1_y.px          DT_NSO_1300_013V1_y
    ## 1113          DT_NSO_1300_011V1_q.px          DT_NSO_1300_011V1_q
    ## 1114          DT_NSO_1300_011V1_y.px          DT_NSO_1300_011V1_y
    ## 1115          DT_NSO_1300_012V1_q.px          DT_NSO_1300_012V1_q
    ## 1116          DT_NSO_1300_012V1_y.px          DT_NSO_1300_012V1_y
    ## 1117          DT_NSO_1300_014V1_q.px          DT_NSO_1300_014V1_q
    ## 1118          DT_NSO_1300_014V1_y.px          DT_NSO_1300_014V1_y
    ## 1119          DT_NSO_1300_015V1_q.px          DT_NSO_1300_015V1_q
    ## 1120          DT_NSO_1300_015V1_y.px          DT_NSO_1300_015V1_y
    ## 1121          DT_NSO_1800_001V202.px          DT_NSO_1800_001V202
    ## 1122          DT_NSO_1800_001V203.px          DT_NSO_1800_001V203
    ## 1123          DT_NSO_1800_001V204.px          DT_NSO_1800_001V204
    ## 1124          DT_NSO_1800_004V202.px          DT_NSO_1800_004V202
    ## 1125          DT_NSO_1800_004V203.px          DT_NSO_1800_004V203
    ## 1126          DT_NSO_1800_004V204.px          DT_NSO_1800_004V204
    ## 1127          DT_NSO_1800_002V202.px          DT_NSO_1800_002V202
    ## 1128          DT_NSO_1800_002V203.px          DT_NSO_1800_002V203
    ## 1129          DT_NSO_1800_002V204.px          DT_NSO_1800_002V204
    ## 1130          DT_NSO_1800_003V202.px          DT_NSO_1800_003V202
    ## 1131          DT_NSO_1800_003V203.px          DT_NSO_1800_003V203
    ## 1132          DT_NSO_1800_003V204.px          DT_NSO_1800_003V204
    ## 1133          DT_NSO_1800_005V102.px          DT_NSO_1800_005V102
    ## 1134          DT_NSO_1800_005V104.px          DT_NSO_1800_005V104
    ## 1135          DT_NSO_1602_004V1_M.px          DT_NSO_1602_004V1_M
    ## 1136          DT_NSO_1602_004V1_Q.px          DT_NSO_1602_004V1_Q
    ## 1137          DT_NSO_1602_003V1_M.px          DT_NSO_1602_003V1_M
    ## 1138          DT_NSO_1602_003V1_Q.px          DT_NSO_1602_003V1_Q
    ## 1139          DT_NSO_1200_012V5_m.px          DT_NSO_1200_012V5_m
    ## 1140          DT_NSO_1200_012V5_q.px          DT_NSO_1200_012V5_q
    ## 1141          DT_NSO_1200_012V5_y.px          DT_NSO_1200_012V5_y
    ## 1142          DT_NSO_1200_012V6_m.px          DT_NSO_1200_012V6_m
    ## 1143          DT_NSO_1200_012V6_q.px          DT_NSO_1200_012V6_q
    ## 1144          DT_NSO_1200_012V6_y.px          DT_NSO_1200_012V6_y
    ## 1145          DT_NSO_1200_012V1_q.px          DT_NSO_1200_012V1_q
    ## 1146          DT_NSO_1200_012V1_y.px          DT_NSO_1200_012V1_y
    ## 1147          DT_NSO_1200_012V7_m.px          DT_NSO_1200_012V7_m
    ## 1148          DT_NSO_1200_012V7_q.px          DT_NSO_1200_012V7_q
    ## 1149          DT_NSO_1200_012V7_y.px          DT_NSO_1200_012V7_y
    ## 1150          DT_NSO_0500_001V5_1.px          DT_NSO_0500_001V5_1
    ## 1151          DT_NSO_0500_001V5_2.px          DT_NSO_0500_001V5_2
    ## 1152          DT_NSO_0400_006V1_1.px          DT_NSO_0400_006V1_1
    ## 1153          DT_NSO_0400_006V1_2.px          DT_NSO_0400_006V1_2
    ## 1154          DT_NSO_0400_035V3_1.px          DT_NSO_0400_035V3_1
    ## 1155          DT_NSO_0400_035V3_2.px          DT_NSO_0400_035V3_2
    ## 1156          DT_NSO_0400_035V7_1.px          DT_NSO_0400_035V7_1
    ## 1157          DT_NSO_0400_035V7_2.px          DT_NSO_0400_035V7_2
    ## 1158         DT_NSO_0400_006V12_1.px         DT_NSO_0400_006V12_1
    ## 1159         DT_NSO_0400_006V12_2.px         DT_NSO_0400_006V12_2
    ## 1160          DT_NSO_0400_007V2_1.px          DT_NSO_0400_007V2_1
    ## 1161          DT_NSO_0400_007V2_2.px          DT_NSO_0400_007V2_2
    ## 1162          DT_NSO_0500_001V8_1.px          DT_NSO_0500_001V8_1
    ## 1163          DT_NSO_0500_001V8_2.px          DT_NSO_0500_001V8_2
    ## 1164          DT_NSO_0400_039V4_1.px          DT_NSO_0400_039V4_1
    ## 1165          DT_NSO_0400_039V4_2.px          DT_NSO_0400_039V4_2
    ## 1166          DT_NSO_0400_039V5_1.px          DT_NSO_0400_039V5_1
    ## 1167          DT_NSO_0400_039V5_2.px          DT_NSO_0400_039V5_2
    ## 1168          DT_NSO_0400_018V1_1.px          DT_NSO_0400_018V1_1
    ## 1169          DT_NSO_0400_018V1_2.px          DT_NSO_0400_018V1_2
    ## 1170          DT_NSO_0400_012V1_1.px          DT_NSO_0400_012V1_1
    ## 1171          DT_NSO_0400_012V1_2.px          DT_NSO_0400_012V1_2
    ## 1172          DT_NSO_0400_020V2_1.px          DT_NSO_0400_020V2_1
    ## 1173          DT_NSO_0400_020V2_2.px          DT_NSO_0400_020V2_2
    ## 1174          DT_NSO_0400_014V3_1.px          DT_NSO_0400_014V3_1
    ## 1175          DT_NSO_0400_014V3_2.px          DT_NSO_0400_014V3_2
    ## 1176          DT_NSO_0400_039V3_1.px          DT_NSO_0400_039V3_1
    ## 1177          DT_NSO_0400_039V3_2.px          DT_NSO_0400_039V3_2
    ## 1178          DT_NSO_0400_036V1_1.px          DT_NSO_0400_036V1_1
    ## 1179          DT_NSO_0400_036V1_2.px          DT_NSO_0400_036V1_2
    ## 1180          DT_NSO_0400_036V0_1.px          DT_NSO_0400_036V0_1
    ## 1181          DT_NSO_0400_036V0_2.px          DT_NSO_0400_036V0_2
    ## 1182            DT_NSO_0400_069V1.px            DT_NSO_0400_069V1
    ## 1183          DT_NSO_0400_069V1-1.px          DT_NSO_0400_069V1-1
    ## 1184            DT_NSO_0400_024V1.px            DT_NSO_0400_024V1
    ## 1185            DT_NSO_0400_024V2.px            DT_NSO_0400_024V2
    ## 1186            DT_NSO_0400_023V1.px            DT_NSO_0400_023V1
    ## 1187            DT_NSO_0400_023V2.px            DT_NSO_0400_023V2
    ## 1188            DT_NSO_0400_038V1.px            DT_NSO_0400_038V1
    ## 1189            DT_NSO_0400_038V2.px            DT_NSO_0400_038V2
    ## 1190            DT_NSO_0400_022V1.px            DT_NSO_0400_022V1
    ## 1191            DT_NSO_0400_022V2.px            DT_NSO_0400_022V2
    ## 1192            DT_NSO_0400_025V1.px            DT_NSO_0400_025V1
    ## 1193            DT_NSO_0400_025V2.px            DT_NSO_0400_025V2
    ## 1194            DT_NSO_0400_021V1.px            DT_NSO_0400_021V1
    ## 1195            DT_NSO_0400_021V2.px            DT_NSO_0400_021V2
    ## 1196            DT_NSO_0400_069V2.px            DT_NSO_0400_069V2
    ## 1197          DT_NSO_0400_069V2-1.px          DT_NSO_0400_069V2-1
    ## 1198            DT_NSO_0400_036V2.px            DT_NSO_0400_036V2
    ## 1199            DT_NSO_0400_036V4.px            DT_NSO_0400_036V4
    ## 1200           DT_NSO_2300_006V_1.px           DT_NSO_2300_006V_1
    ## 1201            DT_NSO_2300_006V1.px            DT_NSO_2300_006V1
    ## 1202           DT_NSO_2300_001A_1.px           DT_NSO_2300_001A_1
    ## 1203            DT_NSO_2300_001A1.px            DT_NSO_2300_001A1
    ## 1204           DT_NSO_2300_004V_1.px           DT_NSO_2300_004V_1
    ## 1205            DT_NSO_2300_004V1.px            DT_NSO_2300_004V1
    ## 1206           DT_NSO_2300_001V_1.px           DT_NSO_2300_001V_1
    ## 1207            DT_NSO_2300_001V1.px            DT_NSO_2300_001V1
    ## 1208           DT_NSO_2300_003V_1.px           DT_NSO_2300_003V_1
    ## 1209            DT_NSO_2300_003V1.px            DT_NSO_2300_003V1
    ## 1210            DT_NSO_2300_036V2.px            DT_NSO_2300_036V2
    ## 1211            DT_NSO_2300_036V4.px            DT_NSO_2300_036V4
    ## 1212            DT_NSO_2200_012V1.px            DT_NSO_2200_012V1
    ## 1213          DT_NSO_2200_012V1_1.px          DT_NSO_2200_012V1_1
    ## 1214            DT_NSO_2200_001V1.px            DT_NSO_2200_001V1
    ## 1215          DT_NSO_2200_001V1_1.px          DT_NSO_2200_001V1_1
    ## 1216            DT_NSO_2200_016V1.px            DT_NSO_2200_016V1
    ## 1217          DT_NSO_2200_016V1_1.px          DT_NSO_2200_016V1_1
    ## 1218            DT_NSO_2200_004V1.px            DT_NSO_2200_004V1
    ## 1219          DT_NSO_2200_004V1_1.px          DT_NSO_2200_004V1_1
    ## 1220            DT_NSO_2200_008V2.px            DT_NSO_2200_008V2
    ## 1221            DT_NSO_2200_008V3.px            DT_NSO_2200_008V3
    ## 1222            DT_NSO_2200_010V4.px            DT_NSO_2200_010V4
    ## 1223          DT_NSO_2200_010V4_1.px          DT_NSO_2200_010V4_1
    ## 1224            DT_NSO_2200_002V1.px            DT_NSO_2200_002V1
    ## 1225          DT_NSO_2200_002V1_1.px          DT_NSO_2200_002V1_1
    ##                                                                                                                                                                      tbl_eng_nm
    ## 1                                                                                                                                                 BALANCE OF PAYMENTS, by month
    ## 2                                                                                                                           WEEKLY PRICES OF MAIN PRODUCTS AND GASOLINE, aimags
    ## 3                                                                                                    CONSUMER PRICE INDEX IN AIMAGS, compared with the previous month, by group
    ## 4                                                                                  CONSUMER PRICE INDEX IN AIMAGS, compared with the same period of the previous year, by group
    ## 5                                                                                          CONSUMER PRICE INDEX IN AIMAGS, compared with the end of the previous year, by group
    ## 6                                                                                                                        NATIONAL BASE CONSUMER PRICE INDEX, by group and month
    ## 7                                                                                                                                   WEEKLY PRICES OF MAIN PRODUCTS AND GASOLINE
    ## 8                                                                                                                                  NATIONAL CONSUMER PRICE INDEX, 1991-1-16=100
    ## 9                                                                                                                CONSUMER PRICE INDEX, by group, compared to the previous month
    ## 10                                                                                                     CONSUMER PRICE INDEX, by group, compared to the end of the previous year
    ## 11                                                                                     REGIONAL CONSUMER PRICE INDEX, by group,compared to the same period of the previous year
    ## 12                                                                                            REGIONAL CONSUMER PRICE INDEX, by group, compared to the end of the previous year
    ## 13                                                                                                      REGIONAL CONSUMER PRICE INDEX, by group, compared to the previous month
    ## 14                                                                                             CONSUMER PRICE INDEX, by group, compared to the same period of the previous year
    ## 15                                                                                                 CONSUMER PRICE INDEX IN THE CAPITAL, by groups, compared with previous month
    ## 16                                                                          NATIONAL CONSUMER PRICE INDEX, by groups and percent changes compared with the end of previous year
    ## 17                                                                                                              NATIONAL CONSUMER PRICE INDEX, by group, monthly percent change
    ## 18                                                                 NATIONAL CONSUMER PRICE INDEX, by groups and percent changes, compared with the same period of previous year
    ## 19                                                                                       CONSUMER PRICE INDEX IN THE CAPITAL, by groups, compared with the end of previous year
    ## 20                                                                               CONSUMER PRICE INDEX IN THE CAPITAL, by groups, compared with the same period of previous year
    ## 21                                                                                                                                                               INFLATION RATE
    ## 22                                                               AVERAGE PRICE OF MAIN SELECTED COMMODITIES, by type of goods and services, aimags and the Capital and by month
    ## 23                                                                                             AVERAGE ANNUAL CONCENTRATIONS OF AIR POLLUTANTS, by station location and by year
    ## 24                                                                                                                               WATER QUALITY, by station location and by year
    ## 25                                                                                                                 UNIFIED LAND TERRITORY OF MONGOLIA, by main type and by year
    ## 26                                                                                            REPORT ON LAND OWNED BY MONGOLIAN CITIZENS, by aimags and the capital and by year
    ## 27                                                                                                                          FOREST FIRES, by aimags and the capital and by year
    ## 28                                                                                                                 FOREST HARVEST VOLUME, by aimags and the capital and by year
    ## 29                                                                                                                                        LAND DEGRADATION, by type and by year
    ## 30                                                                                                             DISASTERS AND DAMAGES, by indicator, national total and by month
    ## 31                                                                                     MAXIMUM ALLOWABLE CONCENTRATION OF QUALITY STANDART, by chemical combination and by year
    ## 32                                                                                         CONCENTRATION OF AIR POLLUTION, by location, indicator of air pollution and by month
    ## 33                                                                                                   GREENHOUSE GAS REMOVALS AND EMISSIONS, by chemical combination and by year
    ## 34                                                                  REPORT OF UNIFIED LAND TERRITORY OF MONGOLIA, by aimags and the capital, unified land territory and by year
    ## 35                                                                                                         AVERAGE AIR TEMPERATURE, by station location, indicator and by month
    ## 36                                                                                                          AVERAGE AIR TEMPERATURE, by station location, indicator and by year
    ## 37                                                                                                                       SUM OF PRECIPITATION, by station location and by month
    ## 38                                                                                                                         MAXIMUM WIND SPEED, by station location and by month
    ## 39                                                                                                                        NUMBER OF DUST DAYS, by station location and by month
    ## 40                                                                                                                  NUMBER OF SNOW STORM DAYS, by station location and by month
    ## 41                                                                                                                                              PHYSICAL FLOW ACCOUNT FOR CROPS
    ## 42                                                                                                                                PHYSICAL FLOW ACCOUNTS FOR LIVESTOCK PRODUCTS
    ## 43                                                                                                                                             PHYSICAL ASSET ACCOUNT FOR CROPS
    ## 44                                                                                                                                                  ASSET ACCOUNT FOR LIVESTOCK
    ## 45                                                                                                                                        PHYSICAL FLOW ACCOUNT FOR FERTILIZERS
    ## 46                                                                                                                                         PHYSICAL FLOW ACCOUNT FOR PESTICIDES
    ## 47                                                                                                                                                 PHYSICAL USE TABLE FOR WATER
    ## 48                                                                                                                                              PHYSICAL SUPPLY TABLE FOR WATER
    ## 49                                                                                                       NATIONAL EXPENDITURE FOR ENVIRONMENTAL PROTECTION, by expenditure type
    ## 50                                                                                                  NATIONAL EXPENDITURE FOR ENVIRONMENTAL PROTECTION, by institutional sectors
    ## 51                                                                                    NATIONAL EXPENDITURE FOR ENVIRONMENTAL PROTECTION, by environmental protection activities
    ## 52                                                                                                                                                        MATERIAL FLOW ACCOUNT
    ## 53                                                                                                                                                  ENVIRONMENTAL TAXES ACCOUNT
    ## 54                                                                                                             THE SUPPLY OF PRIMARY AND SECONDARY ENERGY, by economic activity
    ## 55                                                                                                                                    TOTAL SUPPLY OF ENERGY, by energy product
    ## 56                                                                                                                                            TOTAL USE OF ENERGY, by component
    ## 57                                                                                                                                       TOTAL USE OF ENERGY, by energy product
    ## 58                                                                                                                     TOTAL DOMESTIC CONSUMPTION OF ENERGY, by energy products
    ## 59                                                                                                                                     TERMS OF TRADE INDEX, by month, 2015=100
    ## 60                                                                                                                                   TERMS OF TRADE INDEX, by quarter, 2015=100
    ## 61                                                                                                  FOREIGN TRADE TURNOVER, EXPORTS and IMPORTS, BALANCE, by month (cumulative)
    ## 62                                                                                                                FOREIGN TRADE TURNOVER, EXPORTS and IMPORTS, BALANCE, by year
    ## 63                                                                                                                         FOREIGN TRADE MONTHLY TOTAL TURNOVER, EXPORT, IMPORT
    ## 64                                                                                                                          EXPORTS, by commodity groups and month (cumulative)
    ## 65                                                                                                                                        EXPORTS, by commodity groups and year
    ## 66                                                                                                                            EXPORT BY MAIN COMMODITIES, by month (cumulative)
    ## 67                                                                                                                                          EXPORT BY MAIN COMMODITIES, by year
    ## 68                                                                                                                                                 EXPORTS, by country and year
    ## 69                                                                                                                          IMPORTS, by commodity groups and month (cumulative)
    ## 70                                                                                                                                        IMPORTS, by commodity groups and year
    ## 71                                                                                                                            IMPORT BY MAIN COMMODITIES, by month (cumulative)
    ## 72                                                                                                                                          IMPORT BY MAIN COMMODITIES, by year
    ## 73                                                                                                                                                 IMPORTS, by country and year
    ## 74                                                                                                                       EXPORT PRICE INDEX, by commodity group, month, percent
    ## 75                                                                                           IMPORT PRICE INDEX, percent by Statistical indicator, by commodity group and month
    ## 76                                                                                                                                          GENERAL GOVERNMENT DEBT, by quarter
    ## 77                                                                                                                                     REPAYMENT OF GOVERNMENT DEBT, by quarter
    ## 78                                                                                                                                              GROSS EXTERNAL DEBT, by quarter
    ## 79                                                                                                                        GOVERNMENT REVENUE, EXPENDITURE, AND BALANCE, by year
    ## 80                                                                                                         EXPENDITURE OF CENTRAL GOVERNMENT by portfolio of ministers, by year
    ## 81                                                                                  MONGOLIAN GENERAL GOVERNMENT REVENUE, by classification of revenue, by month, by cumulative
    ## 82                                                                                                      REVENUE OF GENERAL GOVERNMENT, by classification of revenue and by year
    ## 83                                                                                                              LOCAL GOVERNMENT REVENUE, by classification of revenue, by year
    ## 84                                                                          MONGOLIAN GENERAL GOVERNMENT EXPENDITURE, by classification of expenditure, by month, by cumulative
    ## 85                                                                                              EXPENDITURE OF GENERAL GOVERNMENT, by classification of expenditure and by year
    ## 86                                                                                                   LOCAL GOVERNMENT EXPENDITURE, by classification of expenditure and by year
    ## 87                                                                                                   EQUILIBRATED BALANCE OF GENERAL GOVERNMENT BUDGET, by month, by cumulative
    ## 88                                                                             GRANTS FROM CENTRAL GOVERNMENT TO LOCAL GOVERNMENT, by region, aimag and the Capital and by year
    ## 89                                                                                                       EXPENDITURE OF LOCAL GOVERNMENT, by aimags and the Capital and by year
    ## 90                                                                                                           REVENUE OF LOCAL GOVERNMENT, by aimags and the Capital and by year
    ## 91                                                                                                                                   ANNUAL CHANGE OF HOUSING PRICE, by percent
    ## 92                                                            AVERAGE PRICE OF APARTMENT, per square meter, by central 6 districts of Ulaanbaatar, and by quarter, in 2007-2021
    ## 93                                                                       AVERAGE PRICE OF APARTMENT, per square meter, by central 6 districts of Ulaanbaatar city, and by month
    ## 94                                                                                                                                               HOUSING PRICE INDEX, by months
    ## 95                                                                                                                                   HOUSING STOCK, by living area, and by year
    ## 96                                                                                                                     COMMISSIONED DWELLING, by type of ownership, and by year
    ## 97                                                                                                     INVESTMENT, by financial sources, technological composition, and by year
    ## 98                                                                                                                                INVESTMENT, by economic activity, and by year
    ## 99                                                                                                              STATE BUDGET INVESTMENT, by aimags and the Capital, and by year
    ## 100                                                                                                             LOCAL BUDGET INVESTMENT, by aimags and the Capital, and by year
    ## 101                                                                                                                        FOREIGN DIRECT INVESTMENT STOCK, by country and year
    ## 102                                                                                                                     FOREIGN DIRECT INVESTMENT STOCK, by country and quarter
    ## 103                                                                                                                      FOREIGN DIRECT INVESTMENT INFLOWS, by country and year
    ## 104                                                                                                                   FOREIGN DIRECT INVESTMENT INFLOWS, by country and quarter
    ## 105                                                                                                                FOREIGN DIRECT INVESTMENT STOCK, by economic sector and year
    ## 106                                                                                                             FOREIGN DIRECT INVESTMENT STOCK, by economic sector and quarter
    ## 107                                                                                                              FOREIGN DIRECT INVESTMENT INFLOWS, by economic sector and year
    ## 108                                                                                                           FOREIGN DIRECT INVESTMENT INFLOWS, by economic sector and quarter
    ## 109                                                                                                                                             SALES OF STOCK MARKET, by month
    ## 110                                                                                                                                   MAIN INDICATORS OF STOCK MARKET, by month
    ## 111                                                                                                                                                      MONEY SUPPLY, by month
    ## 112                                                                                                                                              AGRICULTURE MARKET, by quarter
    ## 113                                                                                                                         OUTSTANDING LOAN, by loan classification, by months
    ## 114                                                                                                           LOANS OUTSTANDING, by region, aimag and the Capital city, by year
    ## 115                                                                                                      OUTSTANDING INDIVIDIAL DEPOSITS, by region, aimag and Capital, by year
    ## 116                                                                                                 OUTSTANDING NON-PERFORMING LOANS, by region, aimag and the Capital, by year
    ## 117                      NUMBER OF HOUSEHOLDS INVOLVED IN LIVESTOCK RISK INSURANCE, NUMBER OF INSURED LIVESTOCK, by region, aimag, the Capital city, soum and district, by year
    ## 118                                                                                                                              EXCHANGE RATES OF FOREIGN CURRENCIES, by month
    ## 119                                                                                                                                          NDICATORS OF STOCK MARKET, by year
    ## 120                                                                                                                                            BALANCE SHEET OF BANKS, by month
    ## 121                                                                                                                                             LOAN RATE, in percent, by month
    ## 122                                                                                              TOTAL DEPOSITS, by region, aimag, the Capital city, soum and district, by year
    ## 123                                                                                      TOTAL OUTSTANDING LOAN, by region, aimag, the Capital city, soum and district, by year
    ## 124                                                                                                                MAIN INDICATORS OF SAVING AND CREDIT COOPERATIVE, by quarter
    ## 125                                                                                                               MAIN INDICATORS OF NON-BANK FINANCIAL INSTITUTION, by quarter
    ## 126                                                                                                               OUTSTANDING MORTGAGE LOANS TO INDIVIDUALS, by type, by months
    ## 127                                                                                                               REAL AND NOMINAL EFFECTIVE EXCHANGE RATE (NEER, REER) monthly
    ## 128                                                                                                                          OUTSTANDING LOANS TO INDIVIDUAL, by type, by month
    ## 129                                                                            OUTSTANDING LOAN OF SMALL AND MEDIUM ENTERPRISES, by classification of economic sector, by month
    ## 130                                                                                           GROSS DOMESTIC PRODUCT, by production approach, by economic activity, and by year
    ## 131                                                                                                                  GROSS NATIONAL INCOME, GROSS DISPOSABLE INCOME, by quarter
    ## 132                                                                          SMALL AND MEDIUM-SIZED LEGAL ENTITIES VALUE ADDED SHARES IN GDP, by economic activity, and by year
    ## 133                                                                                                                   INDUSTRIAL COMPOSITION OF GROSS DOMESTIC PRODUCT, by year
    ## 134                                                                                                                GROSS DOMESTIC PRODUCT, by expenditure approach, and by year
    ## 135                                                                                                                  GROSS DOMESTIC PRODUCT, by expenditure approach, quarterly
    ## 136                                                                                                    GROSS DOMESTIC PRODUCT, by production approach, by quarter, by divisions
    ## 137                                                                               PRIVATE SECTOR VALUE ADDED SHARE TO GROSS DOMESTIC PRODUCT, by economic activity, and by year
    ## 138                                                                          PRIVATE SECTOR VALUE ADDED SHARE TO GROSS DOMESTIC PRODUCT, by aimags and the Capital, and by year
    ## 139                                                                                                                     GROSS DOMESTIC PRODUCT, by income approach, and by year
    ## 140                                                                                                              GROSS DOMESTIC PRODUCT, by aimags and the Capital, and by year
    ## 141                                                                                                                                              GROSS NATIONAL INCOME, by year
    ## 142                                                                                                                                  GROSS DOMESTIC PRODUCT PER CAPITA, by year
    ## 143                                                                                                   GROSS DOMESTIC PRODUCT PER CAPITA, by aimags and the Capital, and by year
    ## 144                                                                                                                                   GROSS NATIONAL INCOME PER CAPITA, by year
    ## 145                                                                                                            GROSS FIXED CAPITAL FORMATION, by economic activity, and by year
    ## 146                                                                                    INDUSTRIAL COMPOSITION OF GROSS DOMESTIC PRODUCT, by aimags and the Capital, and by year
    ## 147                                                                                           GROSS DOMESTIC PRODUCT, by economic activity, aimags and the Capital, and by year
    ## 148                                                                       GROSS DOMESTIC PRODUCT, by production approach, by quarter, by aggregated 10 divisions, by cumulative
    ## 149                                                                                  GROSS DOMESTIC PRODUCT, by production approach, by quarter, by 19 divisions, by cumulative
    ## 150                                                                                                  GROSS DOMESTIC PRODUCT, by expenditure approach, by quarter, by cumulative
    ## 151                                                                                                       INPUT-OUTPUT TABLE, by non-competitive import type, and by size 20x20
    ## 152                                                                                                           INPUT-OUTPUT TABLE, by competitive import type, and by size 20x20
    ## 153                                                                                                                                                 SUPPLY TABLE, by size 48x32
    ## 154                                                                                                                                                    USE TABLE, by size 48x32
    ## 155                                                                                               GROSS DOMESTIC PRODUCT PER PERSON EMPLOYED, by economic activity, and by year
    ## 156                                                                                                   GROSS DOMESTIC PRODUCT PER EMPLOYED, by economic activity, and by quarter
    ## 157                                                                                   ANNUAL CHANGES OF PRODUCTIVITY FOR THE BUSINESS SECTOR, by economic activity, and by year
    ## 158                                                                                                                        NUMBER OF BIRTHS, by mother's age group, and by year
    ## 159                                                                                                                                                        BIRTH RATES, by year
    ## 160                                                                                                                  SEX RATIO AT BIRTH, by aimags and the Capital, and by year
    ## 161                                                                                                                     NUMBER OF ABORTIONS, aimags and the Capital and by year
    ## 162                                                                                                                       MATERNAL MOTLALITY, by soum and discrict, and by year
    ## 163                                                                                                                                NUMBER OF HOSPITAL BEDS, by type and by year
    ## 164                                                                                                            HEALTH INSTITUTION, by type, aimags and the Capital, and by year
    ## 165                                                                                                                              DEATHS, by sex, by diseases groups and by year
    ## 166                                                                                                                NEW CASES OF CANCER, per 10000 population, by type of cancer
    ## 167                                                                                                             NUMBER OF INFANT MORTALITY, aimags and the Capital and by month
    ## 168                                                                                            INFANT MORTALITY RATE, per 1000 live births, aimags and the Capital and by month
    ## 169                                                                                                                              INFANT MORTALITY, by sex, by soum, and by year
    ## 170                                                                                                  INFANT MORTALITY RATE,  per 1000 live births, by sex, by soum, and by year
    ## 171                                                                                            INFANT MORTALITY RATE, per 1000 live births, aimags and the Capital and by month
    ## 172                                                                                                                INFANT MORTALITY, per 1000 live births, by soum, and by year
    ## 173                                                                                                                     NUMBER OF MOTHERS DEVIVERED CHILD, by soum, and by year
    ## 174                                                                                                      NUMBER OF MOTHERS DELIVERED CHILD, aimags and the Capital and by month
    ## 175                                                                               MOTHERS DELIVERED CHILD, BY COVERED ANC FOR 6 MORE TIMES, aimags and the Capital and by month
    ## 176                                                                                                                            LIVE BIRTHS, aimags and the Capital and by month
    ## 177                                                                                                                        LIVE BIRTHS, by sex, by region, by soum, and by year
    ## 178                                                                                                      MATERNAL MORTALITY RATIO,  per 1,000 live births, by soum, and by year
    ## 179                                                                                             NUMBER OF DEATHS, by classification of the leading causes, by soum, and by year
    ## 180                                                                                                                                 DEATHS, aimags and the Capital and by month
    ## 181                                                                                                                    DEATHS IN HOSPITALS, aimags and the Capital and by month
    ## 182                                    PERCENTAGE OF PREGNANT WOMEN WHO HAD FIRST ANTENANTAL CARE VISIT IN THE FRIST 3 MONTHS OF PREGNANCY, aimags and the Capital, and by year
    ## 183                                                                                             UNDER-FIVE MORTALITY, per 1000 live births, aimags and the Capital and by month
    ## 184                                                                                                     EARLY INITIATION OF BREAST-FEEDING, aimags and the Capital and by month
    ## 185                                                                                                               CONGENITAL ABNORMALITIES, aimags and the Capital and by month
    ## 186                                                                                                     BIRTH WEIGTH LOWER THAN 2500 GRAMS, aimags and the Capital and by month
    ## 187                                                                                                                            STILLBIRTHS, aimags and the Capital and by month
    ## 188                                                                                                                     NEONATAL MORTALITY, aimags and the Capital and by month
    ## 189                                                                                          NEONATAL MORTALITY RATE, per 1000 live births, aimags and the Capital and by month
    ## 190                                                                                                               UNDER FIVE MOTLALITY, by sex, by region, by soum, and by year
    ## 191                                                                                              UNDER FIVE MORTALITY RATE (per 1000 live births), by sex, by soum, and by year
    ## 192                                                                 PERCENTAGE OF MOTHERS DELIVERED CHILD, BY COVERED ANC FOR 6 MORE TIMES, aimags and the Capital, and by year
    ## 193                                        ADOLESCENT BIRTH RATE (aged 10–14 years and aged 15–19 years) per 1,000 women in that age group, aimags and the Capital, and by year
    ## 194                                                                                       WOMEN WHO USE OF MODERN METHODS OF CONTRACEPTION, aimags and the Capital, and by year
    ## 195                                                                                                                   UNDER FIVE MOTLALITY, aimags and the Capital and by month
    ## 196                                                                                             MATERNAL MORTALITY, per 100000 live births, aimags and the Capital and by month
    ## 197                                 PERCENTAGE OF WOMEN AGE 15-49 YEARS WHO ARE CURRENTLY MARRIED OR IN UNION WITH UNMET AND PERCENTAGE OF DEMAND FOR FAMILY PLANNING SATISFIED
    ## 198                                                                                                                             DEATHS OF CANCER, per 10000 population, by year
    ## 199                                                                                               INCIDENCE OF COMMUNICABLE DISEASES, by type of diseases, by soum, and by year
    ## 200                                                                                                     INCIDENCE OF COMMUNICABLE DISEASES, aimags and the Capital, and by year
    ## 201                                                                                                   CASES OF COMMUNICABLE DISEASES, by type of selected diseases and by month
    ## 202                                                                                                                                  NEW CASES OF CANCER, by age group, by year
    ## 203                                                                                NEW CASES AND MORTALITY OF CANCER, per 10000 population, aimags and the Capital, and by year
    ## 204                                                                                   FULL-TIME TEACHERS IN GENERAL EDUCATIONAL SCHOOLS, by aimags and the Capital, and by year
    ## 205                                                                                        FULL-TIME TEACHERS IN GENERAL EDUCATIONAL SCHOOLS, by soum and district, and by year
    ## 206                                                                                               NUMBER OF GENERAL EDUCATIONAL SCHOOLS, by aimags and the Capital, and by year
    ## 207                                                                                                              GENERAL EDUCATIONAL SCHOOLS, by soum and district, and by year
    ## 208                                                                                                                 NUMBER OF GENERAL EDUCATIONAL SCHOOLS, by type, and by year
    ## 209                                                                                   FULL-TIME STUDENTS OF GENERAL EDUCATIONAL SCHOOLS, by aimags and the Capital, and by year
    ## 210                                                                                                     TOTAL NUMBER OF PUPILS STUDYING IN GENERAL EDUCATIONAL SCHOOLS, by year
    ## 211                                                               GENERAL EDUCATIONAL SCHOOL'S PUPILS, REQUESTED TO LIVE IN DORMITORIES, by aimags and the Capital, and by year
    ## 212                                                                          GENERAL EDUCATIONAL SCHOOL'S PUPILS, LIVING IN DORMITORIES, by aimags and the Capital, and by year
    ## 213                                                                                    NUMBER OF NEW ENTRANTS TO GENERAL EDUCATIONAL SCHOOLS, by soum and district, and by year
    ## 214                                                                                  PUPIL-TEACHER RATIO IN GENERAL EDUCATIONAL SCHOOLS, by aimags and the Capital, and by year
    ## 215                                                                     EVALUATION OF GENERAL ADMISSION EXAM (DIMENSIONAL SCORING), by sex, aimags and the Capital, and by year
    ## 216                                                                         FULL-TIME GRADUATES FROM GENERAL EDUCATIONAL SCHOOLS, by grade, aimags and the Capital, and by year
    ## 217                                                                                        FULL-TIME STUDENTS OF GENERAL EDUCATIONAL SCHOOLS, by soum and district, and by year
    ## 218                                                                                     FULL-TIME GRADUATES FROM GENERAL EDUCATIONAL SCHOOLS, by soum and district, and by year
    ## 219                                                                   STUDENTS WITH DISABILITIES STUDYING IN GENERAL EDUCATIONAL SCHOOLS, by aimag and the Capital, and by year
    ## 220                                                                                        FULL-TIME TEACHERS IN GENERAL EDUCATIONAL SCHOOLS, by type of ownership, and by year
    ## 221                                                                                                    NET INTAKE RATE (NIR) IN THE FIRST GRADE OF PRIMARY, by sex, and by year
    ## 222                                                                                          GROSS PRIMARY GRADUATION RATIO (GPGR), by sex, aimags and the Capital, and by year
    ## 223                                                                                            GROSS ENROLLMENT RATIO (GER), by sex, grade, aimags and the Capital, and by year
    ## 224                                                                                                     EXPENDITURE ON EDUCATIONAL SECTOR, by type, and year, at current prices
    ## 225                                                                                                     EDUCATIONAL INSTITUTIONS FOR ALL LEVELS, by classification, and by year
    ## 226                                                                               FULL-TIME TEACHERS OF EDUCATIONAL INSTITUTIONS FOR ALL LEVELS, by classification, and by year
    ## 227                                                                                        GRADUATES OF EDUCATIONAL INSTITUTIONS FOR ALL LEVELS, by classification, and by year
    ## 228                                                                                    STUDENTS STUDYING IN ALL LEVELS EDUCATIONAL INSTITUTIONS, by classification, and by year
    ## 229                                                                                        REVENUE AND EXPENDITURE OF HEALTH INSURANCE FUND, by type, and by month (cumulative)
    ## 230                                                                                                                    NUMBER OF INSURED PERSONS FOR HEALTH INSURANCE, by month
    ## 231                                                                                                      REVENUE AND EXPENDITURE OF HEALTH INSURANCE FUND, by type, and by year
    ## 232                                                                              SALES OF ESSENTIAL DRUGS DISCOUNTED FROM HEALTH INSURANCE FUND, by general groups, and by year
    ## 233                                                                                                                 THE NUMBER OF INSURED PERSONS FOR HEALTH INSURANCE, by year
    ## 234                                                                                                EMPLOYEES OF HEALTH ORGANIZATIONS, by specialization categories, and by year
    ## 235                                                                                         INPATIENTS PER 10000 POPULATION, 10 leading classification of diseases, and by year
    ## 236                                                                                                                             INPATIENTS, aimags and the Capital and by month
    ## 237                                                                                                                               NUMBER OF HOSPITAL BEDS, by soum, and by year
    ## 238                                                                                                                 HOSPITAL BEDS, by type, aimags and the Capital, and by year
    ## 239                                                                                                                     NUMBER OF PHYSICIANS, by region, aimags and the Capital
    ## 240                                                                                                                                  NUMBER OF PHYSICIANS, by soum, and by year
    ## 241                                                                                                                  NUMBER OF PHARMACISTS, aimags and the Capital, and by year
    ## 242                                                                                                              NUMBER OF REPORTING HEALTH ORGANIZATIONS, by soum, and by year
    ## 243                                                                                                        NUMBER OF PERSONS PER PHYSICIAN, aimags and the Capital, and by year
    ## 244                                                                                                            NUMBER OF PERSONS PER NURSE, aimags and the Capital, and by year
    ## 245                                                                                                                  NURSES, by profession, aimags and the Capital, and by year
    ## 246                                                                                                           MID LEVEL MEDICAL PERSONNEL, by professions, by soum, and by year
    ## 247                                                                                                                                       EXPENDITURE ON HEALTH SECTOR, by year
    ## 248                                                                           IMMUNIZATION COVERRAGE FOR INFANTS, by types of immunization, aimags and the Capital, and by year
    ## 249                                                                                        REVENUE AND EXPENDITURE OF HEALTH INSURANCE FUND, by type, and by month (cumulative)
    ## 250                                                                                                                                        HEALTH MANAGER, by soum, and by year
    ## 251                                                                                                                                            PHARMACIST, by soum, and by year
    ## 252                                                                             NUMBER OF FULL-TIME TEACHERS IN PRE-SCHOOL INSTITUTIONS, by aimags and the Capital, and by year
    ## 253                                                                                           EMPLOYEES OF PRE-SCHOOL INSTITUTIONS, by sex, aimags and the Capital, and by year
    ## 254                                                                                                             NUMBER OF KINDERGARTENS, by aimags and the Capital, and by year
    ## 255                                                                                                                  NUMBER OF KINDERGARTENS, by soum and district, and by year
    ## 256                                                                                       NUMBER OF CHILDREN IN PRE-SCHOOL INSTITUTIONS, by aimags and the Capital, and by year
    ## 257                                                                                                                     NUMBER OF KINDERGARTENS, by type of ownership, and year
    ## 258                                                                                                                     CHILDREN ENROLLED IN EARLY CHILDHOOD EDUCATION, by year
    ## 259                                                                                          NUMBER OF EMPLOYEES IN PRE-SCHOOLS INSTITUTIONS, by soum and district, and by year
    ## 260                                                                      NUMBER OF CHILDREN WITH DISABILITIES IN PRE-SCHOOL INSTITUTIONS, by aimag and the Capital, and by year
    ## 261                                                                                                      CHILDREN IN PRE-SCHOOL INSTITUTIONS, by soum and district, and by year
    ## 262                                                                    NUMBER OF STUDENTS IN UNIVERSITIES, INSTITUTES AND COLLEGES, by sex, aimags and the Capital, and by year
    ## 263                                                                                       STUDENTS OF UNIVERSITIES, INSTITUTES AND COLLEGES, by professional field, and by year
    ## 264                                                                                                  GRADUATES OF UNIVERSITIES AND COLLEGES, by professional field, and by year
    ## 265                                                                                           STUDENTS IN TERTIARY EDUCATIONAL INSTITUTIONS, by educational degree, and by year
    ## 266                                                                                  NUMBER OF FULL-TIME TEACHERS IN UNIVERSITIES, INSTITUTES AND COLLEGES, by sex, and by year
    ## 267                                                             NUMBER OF GRADUATES OF TERTIARY EDUCATIONAL INSTITUTIONS, by type of ownership, educational degree, and by year
    ## 268                                                      GRADUATES OF DOMESTIC UNIVERSITIES, INSTITUTES AND COLLEGES, by professional field, by educational degree, and by year
    ## 269                                                             STUDENTS OF DOMESTIC TERTIARY EDUCATION INSTITUTIONS, by professional field, by educational degree, and by year
    ## 270                                                                  STUDENTS IN TECHNICAL AND VOCATIONAL EDUCATIONAL INSTITUTIONS, by sex, aimags and the Capital, and by year
    ## 271                                                                            STUDENTS IN TECHNICAL AND VOCATIONAL EDUCATIONAL INSTITUTIONS, by type of ownership, and by year
    ## 272                                                                                               FULL-TIME TEACHERS IN TECHNICAL AND VOCATIONAL EDUCATION INSTITUTIONS, by sex
    ## 273                                                   EMPLOYEES AND FULL-TIME TEACHERS IN TECHNICAL AND VOCATIONAL EDUCATIONAL INSTITUTIONS, by aimag and the capital, and year
    ## 274                                          STUDENTS AND GRADUATES OF VOCATIONAL AND TECHNICAL EDUCATIONAL INSTITUTIONS, by professional field, by field of study, and by year
    ## 275                                          STUDENT AND GRADUATES OF VOCATIONAL AND TECHNICAL EDUCATIONAL INSTITUTIONS, by field of study, aimags and the Capital, and by year
    ## 276                                                                               STUDENTS IN TECHNICAL AND VOCATIONAL EDUCATIONAL INSTITUTIONS, by field of study, and by year
    ## 277                                                           STUDENTS IN TECHNICAL AND VOCATIONAL EDUCATIONAL INSTITUTIONS, by professional field, by field of study, and year
    ## 278                                                                                                                              ADMINISTRATIVE TERRITORIAL DIVISION OF THE MPR
    ## 279                                                                                                                                          CHANGES IN ADMINISTRATIVE DIVISION
    ## 280                                                                                                                                     NUMBER OF AGRICULTURAL PRODUCTION UNITS
    ## 281                                                                                                                                    OUTPUT OF MEAT AND WOOL PRODUCTS by year
    ## 282                                                                                                                                           AGRICULTURAL AREAS, thous.hectars
    ## 283                                                                                                                                                 SOWN AREAS /thous.heactars/
    ## 284                                                                                                                       CROSS HARVEST OF CROP PRODUCTION, by type, thous.tons
    ## 285                                                                                                       PER HECTARE YIELDS OF PRINCIPAL AGRICULTURAL CROPS, by type, centners
    ## 286                                                                                                                       CROSS HAY HARVEST AND LAYING IN OF FODDER, thous.tons
    ## 287                                                                                                                                     NUMBER OF LIVESTOCK HOUSE, thous.pieces
    ## 288                                                                                                                               NUMBER OF MINE AND BORING WELLS, thous.pieces
    ## 289                                                                                                                                      PRODUCTIVITY PER HEAD OF LIVESTOCK, kg
    ## 290                                                                                                                                                  NUMBER OF VETERINARY STAFF
    ## 291                                                                                                                    CROSS AGRICULTURAL OUTPUT, at current prices, mln.togrog
    ## 292                                                                                                    NUMBER OF LIVESTOCK, by sectors (by farm category), by type, thous.heads
    ## 293                                                                                                                                                         NUMBER OF LIVESTOCK
    ## 294                                                                                                                                                     REARING YOUNG LIVESTOCK
    ## 295                                                                                                                              NUMBER OF BREEDING STOCK, by type, thous.heads
    ## 296                                                                                                                                     NUMBER OF PICS AND POULTRY, thous.heads
    ## 297                                                                                                                                        OUTPUT OF MAIN AGRICULTURAL PRODUCTS
    ## 298                                                                                                                                          PRODUCTIVITY PER HEAD OF LIVESTOCK
    ## 299                                                                                                                                        NUMBER OF EDUCATIONAL ESTABLISHMENTS
    ## 300                                                                                                                                      NUMBER OF PUPILS AND STUDENTS, by year
    ## 301                                                                                                 NUMBER OF STUDENTS AT HIGHER EDUCATIONAL ESTABLISHMENTS OF THE MPR, by year
    ## 302                                                                                                                              NUMBER OF GENERAL EDUCATIONAL DAY-TIME SCHOOLS
    ## 303                                                                                      NUMBER OF PUPILS AT GENERAL EDUCATIONAL DAY-TIME SCHOOLS, by aimags and towns (cities)
    ## 304                                                           ENROLMENT OF PUPILS IN DAY-TIME GENERAL EDUCATIONAL SCHOOLS AND LEAVERS FROM DAY-TIME GENERAL EDUCATIONAL SCHOOLS
    ## 305                                                                                                                        TEACHING STAFF BY TUPE OF EDUCATIONAL ESTABLISHMENTS
    ## 306                                                                                                                                         NUMBER OF KINDERGARTENS AND CRECHES
    ## 307                                                                                                      NUMBER OF SCIENTIFIC ORGANIZATIONS AND WORKERS, at the end of the year
    ## 308                                                                                                                                                         MAGAZINE PUBLISHING
    ## 309                                                                                                                                                        NEWSPAPER PUBLISHING
    ## 310                                                                                                                                          NUMBER OF VISITS TO ENTERTAINMENTS
    ## 311                                                                                                                                       CULTURAL AND EDUCATIONAL INSTITUTIONS
    ## 312                                                                                               GROSS INDUSTRIAL OUTPUT, by economic activity, at current prices and by month
    ## 313                                                                                       GROSS INDUSTRIAL OUTPUT, by economic activity, at constant prices of 1967 and by year
    ## 314                                                                                                             PRODUCTION OF MAJOR COMMODITIES, by production type and by year
    ## 315                                                                                                   AVERAGE NUMBER OF WORKERS AND EMPLOYEES, by economic activity and by year
    ## 316                                                                                                                                      BALANCE OF ELECTRICITY ENERGY, by year
    ## 317                                                                                                                                                    BALANCE OF COAL, by year
    ## 318                                                                                                                            AVERAGE NUMBER OF EMPLOYEES IN INDUSTRY, by year
    ## 319                                                                                NUMBER OF HOLIDAY-MAKERS AT HOLIDAY AND REST HOMES, HEALTH RESORTS AND SANATORIA (thousands)
    ## 320                                                                                                                                          BEDS IN HOSPITAL-TYPE INSTITUTIONS
    ## 321                                                                                                                                            MEDICAL PERSONNEL OF MEDIUM RANK
    ## 322                                                                                                                                                           NUMBER OF DOCTORS
    ## 323                                                                                           GROSS DOMESTIC PRODUCT, at 1995 constant prices, by economic activity and by year
    ## 324                                                                                                          FIXED ASSETS OF NATIONAL ECONOMY, by economic activity and by year
    ## 325                                                          PRODUCTIVITY OF LABOUR (NATIONAL INCOME PER WORKERS), at constant prices of 1986, by economic activity and by year
    ## 326                                                                                                      Gross social product, by industries, at current prices, million togrog
    ## 327                                                                                             Gross social product, by industries, at constant prices of 1986, million togrog
    ## 328                                                                                         National income produced, by industries, at constant prices of 1986, million togrog
    ## 329                                                                                                                       GDP, by industries, at current prices, million togrog
    ## 330                                                                                                  National income produced, by industries, at current prices, million togrog
    ## 331                                                                                                                           Total volume of construction work, billion togrog
    ## 332                                                                                                                                   Housing put into operation, thousand sq.m
    ## 333                                                                                                                         Annual number of employed of construction, thousand
    ## 334                                                                                                                       Fixed assets of constuction, by type , million togrog
    ## 335                                                                                                  Investment by financial sources, technological composition, million togrog
    ## 336                                                                                    FIXED ASSETS PUT INTO INTO OPERATION, by economic activity, at current price and by year
    ## 337                                                                                                                                    Investment by industries, million togrog
    ## 338                                                                                                                                  NUMBER OF WORKING AGED POPULATION, by year
    ## 339                                                                                                                                  NUMBER OF EMPLOYEES IN INDUSTRIES, by year
    ## 340                                                                       THE AVERAGE NUMBER OF WORKERS AND EMPLOYEES OF THE NATIONAL ECONOMY, by economic activity and by year
    ## 341                                                               NUMBER OF SPECIALITS WITH HIGHER AND SECONDARY SPECIALIZED EDUCATION ENGAGED IN THE NATIONAL ECONOMY, by year
    ## 342                                                                                                                             POPULATION OF MONGOLIA, by location and by year
    ## 343                                                                                                                                                  BIRTHS, by sex and by year
    ## 344                                                                                                                                                  DEATHS, by sex and by year
    ## 345                                                                                                                               NATURAL INCREASE PER 1000 POPULATION, by year
    ## 346                                                                                                     PERCENTAGE DISTRIBUTION OF THE ETHNIC GROUP, share to total and by year
    ## 347                                                                                                                                        SOCIAL STATUS OF POPULATION, by year
    ## 348                                                                                                                                      MARRIAGES PER 1000 POPULATION, by year
    ## 349                                                                                                                                       DIVORCES PER 1000 POPULATION, by year
    ## 350                                                                                                                                LIFE EXPECTANCY AT BIRTH, by sex and by year
    ## 351                                                                                                                                                  THE LITERACY RATE, by year
    ## 352                                                                                                                                        POPULATION, by age group and by year
    ## 353                                                                                                                                         REAL INCOMES OF POPULATION, by year
    ## 354                                                                                                                       AVERAGE MONTHLY WAGES OF EMPLOYEES, at current prices
    ## 355                                                                               NUMBER OF MOTHERS OF LARGE FAMILIES RECEIVING STATE ALLOWANCES, at current prices and by year
    ## 356                                                                                                                                     PENSIONS, at current prices and by year
    ## 357                                                                                                                    BANK SAVING OF POPULATION, at current prices and by year
    ## 358                                                                                                      CONSUMPTION OF MAIN FOODSTUFFS PER CAPITA, by product type and by year
    ## 359                                                                                                                       GENERAL GOVERNMENT BUDGET, at current prices, by year
    ## 360                                                                                                         STRUCTURE OF GENERAL GOVERNMENT BUDGET, share of total, and by year
    ## 361                                                                                                                        MAIN IMPORT COMMODITIES, by commodities, and by year
    ## 362                                                                                                                         MAIN EXPORT COMMODITIES, by commodities and by year
    ## 363                                                                                                                                             FOREIGN TRADE TURNOVER, by year
    ## 364                                                  SHARE OF SOCIALIST AND CAPITALIST COUNTRIES IN TOTAL VOLUME OF EXPORTS AND IMPORTS OF THE MPR, share of total, and by year
    ## 365                                                                                                RETAIL SALES OF PRINCIPAL COMMODITIES PER CAPITA, by commodities and by year
    ## 366                                                                                                           RETAIL SALES OF PRINCIPAL COMMODITIES, by commodities and by year
    ## 367                                                                                                                                    VOLUME OF RETAIL TRADE TURNOVER, by year
    ## 368                                                                                                                                 VOLUME OF PUBLIC CATERING TURNOVER, by year
    ## 369                                                                                                                 STATE RETAIL TRADE AND PUBLIC CATERING ENTERPRISES, by year
    ## 370                                                                                                           RETAIL TRADE AND PUBLIC CATERING, by aimags and city, and by year
    ## 371                                                                                              FREIGHT TURNOVER OF ALL TYPES OF TRANSPORT, by transportation type and by year
    ## 372                                                                                                    FREIGHT CARRIED BY ALL TYPES OF TRANSPORT, by transport type and by year
    ## 373                                                                                                 PASSENGER TURNOVER OF ALL TYPES OF TRANSPORT, by transport type and by year
    ## 374                                                                                                  PASSENGER CARRIED BY ALL TYPES OF TRANSPORT, by transport type and by year
    ## 375                                                                                                                                                 NUMBER OF VEHICLES, by year
    ## 376                                                                                                                                                 IMPROVED AUTO ROAD, by year
    ## 377                                                                                                                              MAIN INDICATORS OF TELECOMMUNICATIONS, by year
    ## 378                                                                                                                         MAIN INDICATORS OF COMMUNICATIONS SERVICES, by year
    ## 379                                                                                                                            NUMBER OF PUBLIC UTILITIES AND SERVICES, by year
    ## 380                                                                   VOLUME OF RECEIPTS FROM PUBLIC UTILITIES AND SERVICES, by type of services, at current price, and by year
    ## 381                                                                                                                          GOVERNMENT AND CO-OPERATIVE HOUSING STOCK, by year
    ## 382                                                                                                                       SOWN AREAS, by type of crop, bag, khoroo, and by year
    ## 383                                                                                                        HARVESTED CROP, by type of crop, aimags and the Capital, and by year
    ## 384                                                                                                                   HARVESTED CROP, by type of crop, bag, khoroo, and by year
    ## 385                                                                                                            SOWN AREAS, by type of crop, aimags and the Capital, and by year
    ## 386                                                                                      CROP YIELD HARVESTED PER HECTARE, by type of crop, aimags and the Capital, and by year
    ## 387                                                                                                                                              GROSS OUTPUT OF CROPS, by year
    ## 388                                                                                                           NUMBER OF FARM HOUSEHOLDS, by aimags and the Capital, and by year
    ## 389                                                                                                     AVERAGE MARKET PRICE OF CROP PRODUCTS, by month, aimags and the Capital
    ## 390                                                                                           AVERAGE MARKET PRICE OF BALE OF HAY AND WHEAT BRAN, by month, soums and districts
    ## 391                                                                                                                                                 AGRICULTURAL AREAS, by year
    ## 392                                                                                                                    TOTAL SOWN AREAS, by aimags and the Capital, and by year
    ## 393                                                              SOWN AREA OF CEREALS, POTATOES, VEGETABLES, FODDER CROPS, by type of crop, aimags and the Capital, and by year
    ## 394                                                                       HARVESTED CROP OF CEREALS, POTATOES, VEGETABLES, FODDER CROPS, by aimags and the Capital, and by year
    ## 395                                                                        YIELDS OF STAPLE AGRICULTURAL CROPS PER HECTAR, by type of crop, aimags and the Capital, and by year
    ## 396                                                                                           GROSS HAY HARVEST AND LAYING-IN OF FODDER, by aimags and the Capital, and by year
    ## 397                                                                                            HANDMADE FODDER, IN TERMS OF FODDER UNIT, by aimags and the Capital, and by year
    ## 398                                                                                      SOWN AREAS OF FRIUTS AND BERRIES, by type of crop, aimags and the Capital, and by year
    ## 399                                                                                          HARVESTED FRIUTS AND BERRIES, by type of crop, aimags and the Capital, and by year
    ## 400                                                                                                 SOWN AREAS OF FRUITS AND BERRIES, by type of crop, bag, khoroo, and by year
    ## 401                                                                                         NUMBER OF TOTAL BUSH AND TREES OF FRUITS, by type of crop, bag, khoroo, and by year
    ## 402                                                                                                        NUMBER OF FARMER ENTERPRISES, by aimags and the Capital, and by year
    ## 403                                                CONSTRUCTION, CAPITAL REPAIRS AND MAINTENANCES, by type of construction, aimags and the Capital, and by quarter (cumulative)
    ## 404                                                     GROUPING OF CONSTRUCTION ENTERPRISES, by amount of completed construction, capital repairs and maintenance, and by year
    ## 405                                                                            STRUCTURE OF CONSTRUCTION, CAPITAL REPAIRS AND MAINTENANCE, by type of construction, and by year
    ## 406                                                                            COMMISSIONED CONSTRUCTION AND CAPITAL REPAIRS, by type and capacity of construction, and by year
    ## 407                                                                          CONSTRUCTION, CAPITAL REPAIRS AND MAINTENANCE, by type of enterprises, and by quarter (cumulative)
    ## 408                                                    COMMISSIONED CONSTRUCTION, CAPITAL REPAIRS AND MAINTENANCE, by type of construction, aimags and the Capital, and by year
    ## 409                                                                                                                        CONSTRUCTION COST INDEX,construction type by quarter
    ## 410                                                                                                                                        OTHER INDICATORS OF CULTURE, by year
    ## 411                                                                                                                                        PUBLIC LIBRARIES INDICATORS, by year
    ## 412                                                                      PUBLIC LIBRARIES, PERMANENT READERS, NUMBER OF LIBRARY BOOK STOCK, aimags and the Capital, and by year
    ## 413                                                                                                                       NUMBER OF CINEMA, aimags and the Capital, and by year
    ## 414                                                                                                  CULTURAL CENTERS, NUMBER OF EMPLOYEES, aimags and the Capital, and by year
    ## 415                                                                                                        EXHIBITS AND VISITORS OF MUSEUM, aimags and the Capital, and by year
    ## 416                                                                          PERFORMANCES AND SPECTATORS OF PROPESSIONAL ART ORGANIZATIONS, aimags and the Capital, and by year
    ## 417                                                                                                      NUMBER OF SEATS IN PUBLIC LIBRARY, aimags and the Capital, and by year
    ## 418                                                                                             NUMBER OF CULTURAL CENTER SEATING CAPACITY, aimags and the Capital, and by year
    ## 419                                                                                                     EMPLOYEES IN THE ARTS AND CULTURAL INDUSTRIES, by type of organizations
    ## 420                                                                                                      GROSS INDUSTRIAL OUTPUT, by subdivision and by month (2003.01-2020.06)
    ## 421                                                                                                                        GROSS INDUSTRIAL OUTPUT, by subdivision and by month
    ## 422                                                                                                          COMPOSITION OF GROSS INDUSTRIAL OUTPUT, by subdivision and by year
    ## 423                                                                                                       SALES OF INDUSTRIAL PRODUCTION, by Aimag and the Capital, and by year
    ## 424                                                                                                               PRODUCTION OF MAJOR COMMODIES, by Major commodities and Month
    ## 425                                                                                                  SOLD PRODUCTION OF INDUSTRY, by subdivision and by month (2001.01-2020.06)
    ## 426                                                                                                                              SOME INDUSTRIAL PRODUCTION PER CAPITA, by year
    ## 427                                                                                                                                             BALANCE OF ELECTRICITY, by year
    ## 428                                                                                                                                                    BALANCE OF COAL, by year
    ## 429                                                                                                                                          BALANCE OF THERMAL ENERGY, by year
    ## 430                                                                                                                                    PRODUCTION OF MAJOR COMMODITIES, by year
    ## 431                                                                                      SEASONALLY ADJUSTED INDUSTRIAL PRODUCTION INDEX, 2010=100, by subdivision and by month
    ## 432                                                                                      SEASONALLY ADJUSTED INDUSTRIAL PRODUCTION INDEX, 2015=100, by subdivision and by month
    ## 433                                                                                                          INDUSTRIAL PRODUCTION INDEX, 2010=100, by subdivision and by month
    ## 434                                                                                                            INDUSTRIAL PRODUCER PRICE INDEX, 2015=100, by division and month
    ## 435                                                                                                             INDUSTRIAL PRODUCTION INDEX, 2015=100, by division and by month
    ## 436                                                                                                                    SOLD PRODUCTION OF INDUSTRY, by subdivision and by month
    ## 437                                                                                                                                             GROSS LIVESTOCK OUTPUT, by year
    ## 438                                                                                                  SURVIVALS OF YOUNG ANIMALS, by type of livestock, bag, khoroo, and by year
    ## 439                                                                                    AVERAGE SURVIVAL RATE PER 100 FEMALE BREEDING STOCK, aimags and the Capital, and by year
    ## 440                                                                                            NUMBER OF SURVIVAL, by type of livestock, aimags and the Capital, and by quarter
    ## 441                                                                                       LOSSES OF ADULT ANIMALS, by type of livestock, aimags and the Capital, and by quarter
    ## 442                                                                                      NUMBER OF LIVESTOCK DIED FROM DISAESES, by type of livestock, bag, khoroo, and by year
    ## 443                                                                                         NUMBER OF MISCARRAGE FEMALE ANIMALS, by type of livestock, bag, khoroo, and by year
    ## 444                                                                                             NUMBER OF BARREN FEMALE ANIMALS, by type of livestock, bag, khoroo, and by year
    ## 445                                                                                                                         NUMBER OF PIGS, aimags and the Capital, and by year
    ## 446                                                                                                                      NUMBER OF POULTRY, aimags and the Capital, and by year
    ## 447                                                                                                    MAIN AGRICULTURAL PRODUCTION PER CAPITA, by type of product, and by year
    ## 448                                                                                                         NUMBER OF LIVESTOCK, by type of livestock, bag, khoroo, and by year
    ## 449                                                                                                    NUMBER OF BREEDING STOCK, by type of livestock, bag, khoroo, and by year
    ## 450                                                                                                     LOSSES OF ADULT ANIMALS, by type of livestock, bag, khoroo, and by year
    ## 451                                                                                                               NUMBER OF DOMESTIC ANIMALS, by type, bag, khoroo, and by year
    ## 452                                                                                                AVERAGE MARKET PRICE OF LIVESTOCK PRODUCTS, by month, aimags and the Capital
    ## 453                                                                                                     PRODUCTION OF AGRICULTURE, by type, aimags and the Capital, and by year
    ## 454                                                                                                            AVERAGE MARKET PRICE OF LIVESTOCK, by month, soums and districts
    ## 455                                                                                                                                     NUMBER OF YAK, bag, khoroo, and by year
    ## 456                                                                                                                                  MAIN INDICATORS OF SCIENCE SECTOR, by year
    ## 457                                                                                                   NUMBER OF FULL-TIME EMPLOYEES WITH SCIENTIFIC DEGREES AND TITLES, by year
    ## 458                                                                                          INBOUND FOREIGN PASSENGERS, by purpose of travel, geographical region, and by year
    ## 459                                                                                                NUMBER OF OUTBOUND MONGOLIAN, by sex, purpose of visit, country, and by year
    ## 460                                                                                          NUMBER OF INBOUND TRANSPORTATIONS, type of transport, border crossing, and by year
    ## 461                                                                                            NUMBER OF INBOUND PASSENGERS, by sex, age group, purpose of travel, and by month
    ## 462                                                                                        NUMBER OF OUTBOUND TRANSPORTATIONS, type of transport, border crossings, and by year
    ## 463                                                                                             NUMBER OF INBOUND PASSENGERS, by sex, age group, duration of stay, and by month
    ## 464                                                                                            NUMBER OF OUTBOUND MONGOLIAN, by sex, age group, purpose of travel, and by month
    ## 465                                                                                             NUMBER OF OUTBOUND MONGOLIAN, by sex, age group, duration of stay, and by month
    ## 466                                                                                                                 NUMBER OF OUTBOUND MONGOLIAN, by sex, country, and by month
    ## 467                                                                                                                      TOTAL TRADE TURNOVER, by trade sub-sector, and by year
    ## 468                                                                                                               TOTAL TRADE TURNOVER, by aimags and the Capital, and by month
    ## 469                                                                                                       TOTAL TRADE TURNOVER, by regions, aimags and the Capital, and by year
    ## 470                                                                                                     KEY INDICATORS OF TRANSPORTATION SECTOR, by national level, and by year
    ## 471                                                 NUMBER OF VEHICLES PASSED THE TECHNICAL INSPECTION, by type, region, aimags and the Capital, soum and district, and by year
    ## 472                                                 NUMBER OF VEHICLES PASSED THE TECHNICAL INSPECTION, by age, region, aimags and the Capitall, soum and district, and by year
    ## 473                                                                                         NUMBER OF REGISTERED VEHICLES, by type, region, aimags and the Capital, and by year
    ## 474                                                                                          NUMBER OF REGISTERED VEHICLES, by age, region, aimags and the Capital, and by year
    ## 475                                                                                                       NUMBER OF IMPORTED VEHICLES, by country, type of vehicle, and by year
    ## 476                                                                                                                      THE NUMBER OF POLITICAL POSITIONS, by sex, and by year
    ## 477                                                                                                           THE NUMBER OF HEAD OF GENERAL ADMINISTRATION, by sex, and by year
    ## 478                                                               CIVIL SERVANTS OF MONGOLIA, by classification, sex, age group, aimags and the Capital, and by year, 1995-2022
    ## 479                                                                                                     GENERAL ADMINISTRATION CIVIL SERVANTS OF MONGOLIA, by rank, and by year
    ## 480                                                                              CIVIL SERVANTS OF MONGOLIA, by sex, age group, aimags and the Capital, and by year, since 2023
    ## 481                                                                          CIVIL SERVANTS OF MONGOLIA, by classification, sex, aimag and the Capital, and by year, since 2023
    ## 482                                        1.3.1 PROPORTION OF POPULATION COVERED BY SOCIAL PROTECTION FLOORS/SYSTEMS PERCENT, by sex, age group, location, region, and by year
    ## 483                                                                      5.5.2 PROPORTION OF WOMEN IN MANAGERIAL POSITIONS PERCENT, by age group, location, region, and by year
    ## 484                                                                                                           8.2.1 ANNUAL GROWTH RATE OF REAL GDP PER EMPLOYED PERSON, by year
    ## 485                                                          8.5.1 AVERAGE HOURLY EARNINGS OF FEMALE AND MALE EMPLOYEES, by occupation, age, sex, location, region, and by year
    ## 486                                                                                          8.5.2 UNEMPLOYMENT RATE, by sex, age group, persons with disabilities, and by year
    ## 487                                              8.6.1 PROPORTION OF YOUTH (AGED 15-24) NOT IN EDUCATION, EMPLOYMENT OR TRAINING PERCENT, by sex, location, region, and by year
    ## 488                                                                                     8.8.1 INCIDENCE RATES OF FATAL AND NON-FATAL OCCUPATIONAL INJURIES, by sex, and by year
    ## 489                                              8.7.1 NUMBER OF CHILDREN AGED 5-17 YEARS ENGAGED IN CHILDLABOUR, by sex, age group, location and region, and by year of survey
    ## 490                                                                                       10.4.1 LABOUR SHARE OF GDP, COMPRISING WAGES AND SOCIAL PROTECTION TRANSFERS, by year
    ## 491                                                      1.A.2 PROPORTION OF TOTAL GOVERNMENT SPENDING ON ESSENTIAL SERVICES (EDUCATION, HEALTH AND SOCIAL PROTECTION), by year
    ## 492                                                                                     EMPL-1 EMPLOYMENT-TO-POPULATIAN RATIO PERCENT, by sex, age group, location, and by year
    ## 493                                                     EARN-1 WORKING POVERTY RATE OF EMPLOYED PERSONS (WPRE, percent), by sex, age group, aimags and the Capital, and by year
    ## 494                                                                                 EARN-2 EMPLOYEES WITH LOW PAY RATE (ELPR), by sex, age group, location, region, and by year
    ## 495                                                TIME-1. EMPLOYMENT IN EXCESSIVE WORKING TIME (more than 48 hours per week), by sex, age group, location, region, and by year
    ## 496                                                                                      EQUA-1 OCCUPATIONAL SEGREGATION: FEMALE SHARE OF EMPLOYMENT by occupation, and by year
    ## 497                                                                                                          SECU-1 PROPORTION OF POPULATION RECEIVING OLD-AGE PENSION, by year
    ## 498                                                                                                                                DIAL-1 Trade union density rate (percentage)
    ## 499                                                                                                    CONT-1. CHILDREN NOT IN SCHOOL (PERCENTAGE), by sex, region, and by year
    ## 500                                                                                         CONT-2 ESTIMATED PERCENTAGE OF WORKING AGE POPULATION WHO ARE HIV POSITIVE, by year
    ## 501                                                                                          CONT-4 INCOME INEQUALITY (90:10 RATIO), by age, sex, location, region, and by year
    ## 502                                                                                                         CONT-5 INFLATION AVERAGE RATE OF YEAR (CPI), by region, and by year
    ## 503                                                                                                    CONT-6 EMPLOYMENT, by classification of economic activities, and by year
    ## 504                                                                        CONT-7 EDUCATION OF ADULT POPULATION (ADULT LITERACE RATE),IN PERCENTAGE, by sex, and by census year
    ## 505                                                                            REGISTERED UNEMPLOYED, by age group, sex, aimags and the Capital, and by month /2008.01-2024.04/
    ## 506                                                                      REGISTERED UNEMPLOYED, by education level, sex, aimags and the Capital, and by month /2008.01-2024.04/
    ## 507                                                                                         REGISTERED UNEMPLOYED MOVEMENT, by aimags and the Capital, and by month /2014-2021/
    ## 508                                                                           REGISTERED JOB SEEKERS, by age group, sex, aimags and the Capital, and by month /2014.01-2024.04/
    ## 509                                                                     REGISTERED JOB SEEKERS, by education level, sex, aimags and the Capital, and by month /2014.01-2024.04/
    ## 510                                                                                                    INFORMAL EMPLOYMENT, by sex, region, aimags and the Capital, and by year
    ## 511                                                                                   INFORMAL EMPLOYMENT, by production unit type, region, aimag and the capital, gender, year
    ## 512                                                                 INFORMAL EMPLOYMENT, by classification of economic activities , region, aimag and the capital, gender, year
    ## 513                                                                                   INFORMAL EMPLOYMENT, by status in employment, region, aimag and the capital, gender, year
    ## 514                                                                                                            FOREIGN WORKERS WITH LABOUR CONTRACT, by country, and by quarter
    ## 515                                                                                                  FOREIGN WORKERS WITH LABOUR CONTRACT, by economic activity, and by quarter
    ## 516                                                                                             FOREIGN WORKERS WITH LABOUR CONTRACT, by aimags and the Capital, and by quarter
    ## 517                                                                                                     LABOUR INTERESTS DISPUTE, by region, aimag and the capital, and by year
    ## 518                                                                                       EMPLOYEES WORKING ABROAD ON A CONTRACTUAL BASIS, by economic activity, and by quarter
    ## 519                                                                                        SHARE TO TOTAL EXPORTS AND IMPORTS OF SMALL AND MEDIUM-SIZED LEGAL ENTITIES, by year
    ## 520                                                                          SMALL AND MEDIUM-SIZED LEGAL ENTITIES VALUE ADDED SHARES IN GDP, by economic activity, and by year
    ## 521                                                                     SMALL AND MEDIUM-SIZED LEGAL ENTITIES VALUE ADDED SHARES IN GDP, by aimags and the Capital, and by year
    ## 522                                                                                                    SMALL AND MEDIUM-SIZED LEGAL ENTITIES, by aimag and Capital, and by year
    ## 523                                                                                                    SMALL AND MEDIUM-SIZED LEGAL ENTITIES, by economic activity, and by year
    ## 524                                                                           SMALL AND MEDIUM-SIZED LEGAL ENTITIES, by employment size group and sales size group, and by year
    ## 525                                                                                COOPERATIVES REGISTERED IN THE BUSINESS REGISTRY, MEMBERS, by soum and district, and by year
    ## 526                                                             REGISTERED COOPERATIVES STAKEHOLDER’S CAPITAL THE BUSINESS REGISTER DATABASE, by soum and district, and by year
    ## 527                                                                NUMBER OF LEGAL ENTITIES REGISTERED IN THE BUSINESS REGISTRY, by activity status and legal type, and by year
    ## 528                                                                                              NUMBER OF LEGAL ENTITIES, by ownership type, soum and district, and by quarter
    ## 529                                                                                       NUMBER OF LEGAL ENTITIES, by employment size class and ownership type, and by quarter
    ## 530                                                                               NUMBER OF LEGAL ENTITIES, by size group of employees and type of legal status, and by quarter
    ## 531                                                                                    NUMBER OF LEGAL ENTITIES, by size group of employment, soum and district, and by quarter
    ## 532                                                         NUMBER OF LEGAL ENTITIES REGISTERED IN THE BUSINESS REGISTRY, by activity status, soum and district, and by quarter
    ## 533                                                                            NUMBER OF ENTITIES REGISTERED IN DATABASE, by type of ownership and activity status, and by year
    ## 534                                                                                        NUMBER OF LEGAL ENTITIES, by type of legal status, soum and district, and by quarter
    ## 535                                                                    NUMBER OF LEGAL ENTITIES, by section of economic activities and type of legal status, by and the quarter
    ## 536                                                                                        NUMBER OF LEGAL ENTITIES, by economic activity and type of ownership, and by quarter
    ## 537                                                                                       NUMBER OF LEGAL ENTITIES, by economic activity and employment size class, and by year
    ## 538                                                                    REGISTERED COOPERATIVES, AND MEMBER IN THE BUSINESS REGISTER DATABASE, by economic activity, and by year
    ## 539                                                          REGISTERED COOPERATIVES STAKEHOLDER’S CAPITAL IN THE BUSINESS REGISTER DATABASE, by economic activity, and by year
    ## 540                                                                         NUMBER OF LEGAL ENTITIES, by division of economic activity and type of legal status, and by quarter
    ## 541                                                                            NUMBER OF LEGAL ENTITIES, by division of economic activity and type of ownership, and by quarter
    ## 542                                                       NUMBER OF LEGAL ENTITIES REGISTERED IN DATABASE, by division of economic activity and activity status, and by quarter
    ## 543                                                                      NUMBER OF LEGAL ENTITIES, by division of economic activity and size group of employees, and by quarter
    ## 544                                                        REGISTERED COOPERATIVES AND MEMBER IN THE BUSINESS REGISTER DATABASE, by divisions of economic activity, and by year
    ## 545                                                      REGISTERED COOPERATIVES STAKEHOLDER’S CAPITAL IN THE BUSINESS REGISTER, by divisions of economic activity, and by year
    ## 546                                                                            NUMBER OF LEGAL ENTITIES, by group of economic activity and type of legal status, and by quarter
    ## 547                                                                               NUMBER OF LEGAL ENTITIES, by group of economic activity and type of ownership, and by quarter
    ## 548                                             NUMBER OF LEGAL ENTITIES REGISTERED IN THE BUSINESS REGISTRY, by group of economic activity and activity status, and by quarter
    ## 549                                                                                 NUMBER OF LEGAL ENTITIES, by group of economic activity and activity status, and by quarter
    ## 550                                                                                           NUMBER OF LEGAL ENTITIES, by economic activity, soum and district, and by quarter
    ## 551                                                      NUMBER OF LEGAL ENTITIES REGISTERED IN THE BUSINESS REGISTRY, by economic activity and activity status, and by quarter
    ## 552                                                                                                    RESIDENT POPULATION IN MONGOLIA, by sex, single year of age, and by year
    ## 553                                                                                                             POPULATION OF MONGOLIA, by sex, single year of age, and by year
    ## 554                                                                                                           MID-YEAR TOTAL POPULATION, by aimags and the Capital, and by year
    ## 555                                                                                                                   MID-YEAR RESIDENT POPULATION, by bag, khoroo, and by year
    ## 556                                                                                                                      POPULATION OF MONGOLIA, by sex, age group, and by year
    ## 557                                                                                                    POPULATION OF MONGOLIA, by location, aimags and the Capital, and by year
    ## 558                                                                                                      RESIDENT POPULATION IN MONGOLIA, by location, bag, khoroo, and by year
    ## 559                                                                                                      NUMBER OF HOUSEHOLDS, by location, aimags and the Capital, and by year
    ## 560                                                                                                                     NUMBER OF HOUSEHOLDS, by soum and discrict, and by year
    ## 561                                                                                                                 NUMBER OF HOUSEHOLDS, by location, bag, khoroo, and by year
    ## 562                                                                                                           NUMBER OF ORPHAN CHILDREN, by aimags and the Capital, and by year
    ## 563                                                                                                CHILD LIVING WITH ONE OF THE PARENTS, by aimags and the Capital, and by year
    ## 564                                                                     NUMBER OF MOTHERS HEADED HOUSEHOLD, number of household members, by aimags and the Capital, and by year
    ## 565                                                                         HOUSEHOLDS WITN 4 AND MORE CHILDREN AGED BELOW 18 YEARS OLD, by aimags and the Capital, and by year
    ## 566                                                                          Number of old aged living single headed households, by sex, by aimags and the Capital, and by year
    ## 567                                                                                                                       POPULATION OF MONGOLIA, by location, sex, and by year
    ## 568                                                                                                                NUMBER OF HOUSEHOLDS, by aimags and the Capital, and by year
    ## 569                                                                                                                             DENSITY, by aimags and the Capital, and by year
    ## 570                                                                                                                                  DENSITY, by soum and discrict, and by year
    ## 571                                                                                                                    DEPENDENCY RATIO, by aimags and the Capital, and by year
    ## 572                                                                                                                         DEPENDENCY RATIO, by soum and district, and by year
    ## 573                                                                                                                POPULATION MIGRATION, by aimags and the Capital, and by year
    ## 574                                                                                                     RESIDENT POPULATION IN MONGOLIA, by age group, bag, khoroo, and by year
    ## 575                                                                                                           RESIDENT POPULATION IN MONGOLIA, by sex, bag, khoroo, and by year
    ## 576                                                                               RESIDENT POPULTATION AGED 15 AND OVER, by age group, sex, marital status, and by census years
    ## 577                                                                                                            HEAD OF HOUSEHOLD PERSON, by aimags and the Capital, and by year
    ## 578                                                                    MOTHERS WHO HEAD HOUSEHOLD WITH CHILDREN AGED BELOW 18 YEARS OLD, by aimags and the Capital, and by year
    ## 579                                                                          BIRTHS, DEATHS AND NATURAL INCREASE PER 1000 POPULATION, by aimags and the Capital, and by quarter
    ## 580                                                                                                                                       NUMBER OF BIRTHS, by sex, and by year
    ## 581                                                                                                                                       NUMBER OF DEATHS, by sex, and by year
    ## 582                                                                                                               NUMBER OF BIRTHS, by sex, aimags and the Capital, and by year
    ## 583                                                                                                                    NUMBER OF DEATHS, by sex, soum and district, and by year
    ## 584                                                                                                               NUMBER OF DEATHS, by sex, aimags and the Capital, and by year
    ## 585                                                                                                                    NUMBER OF BIRTHS, by sex, soum and discrict, and by year
    ## 586                                                                                                                         NUMBER OF DEATHS, by educational level, and by year
    ## 587                                                                                                                            NUMBER OF DEATHS, by sex, age group, and by year
    ## 588                                                                                                         NUMBER OF DEATHS, by age group, aimags and the Capital, and by year
    ## 589                                                                                                              NUMBER OF DEATHS, by age group, soum and district, and by year
    ## 590                                                                                                    NUMBER OF MARRIAGES AND DIVORCES, by aimags and the Capital, and by year
    ## 591                                                                                                         NUMBER OF MARRIAGES AND DIVORCES, by soum and district, and by year
    ## 592                                                                                                                        REGISTERED MARRIAGES, by sex, age group, and by year
    ## 593                                                                                                                REGISTERED MARRIAGES, by sex, soum and district, and by year
    ## 594                                                                                         MARRIAGES AND DIVORCES, by per 1000 population, aimags and the Capital, and by year
    ## 595                                                                                              MARRIAGES AND DIVORCES, by per 1000 population, soum and district, and by year
    ## 596                                                                                                                              DEVORCES, by duration of marriage, and by year
    ## 597                                                                                                                                  CHILD ADOPTIONS, by age group, and by year
    ## 598                                                                                                                        NUMBER OF BIRTHS, by mother's age group, and by year
    ## 599                                                                                                NUMBER OF BIRTHS, by mother's age group, aimags and the Capital, and by year
    ## 600                                                                                                     NUMBER OF BIRTHS, by mother's age group, soum and discrict, and by year
    ## 601                                                                              BIRTH, DEATH AND NATURAL INCREASE, by per 1000 population, aimags and the Capital, and by year
    ## 602                                                                                                                      DEATH PER 1000, by sex, soum and district, and by year
    ## 603                                                                                                                                                        BIRTH RATES, by year
    ## 604                                                                                                                         CRUDE BIRTH RATE, by soum and district, and by year
    ## 605                                                                                                       LIFE EXPECTANCY AT BIRTH, by sex, aimags and the Capital, and by year
    ## 606                                                                                                                  SEX RATIO AT BIRTH, by aimags and the Capital, and by year
    ## 607                                                                                                                       SEX RATIO AT BIRTH, by soum and discrict, and by year
    ## 608                                                                                                                    NUMBER OF BIRTHS, by aimags and the Capital, and by year
    ## 609                                                                                                                    NUMBER OF DEATHS, by aimags and the Capital, and by year
    ## 610                                                                                                                WOMEN WHO GAVE BIRTH, by aimags and the Capital, and by year
    ## 611                                                                                                            WOMEN WHO GAVE BIRTH, by mother's educational level, and by year
    ## 612                                                                                    WOMEN WHO GAVE BIRTH, by mother's educational level, aimags and the Capital, and by year
    ## 613                                                                                         WOMEN WHO GAVE BIRTH, by mother's educational level, soum and district, and by year
    ## 614                                                                                                                                        LIFE EXPECTANCY, by sex, and by year
    ## 615                                                                                                WOMEN WHO GAVE BIRTH, by marital status, aimags and the Capital, and by year
    ## 616                                                                                                     WOMEN WHO GAVE BIRTH, by marital status, soum and district, and by year
    ## 617                                                                                                       ADOPTION, by per 1000 population, aimags and the Capital, and by year
    ## 618                                                                                                                                 ADOPTION, by soum and district, and by year
    ## 619                                                                                                                                 NUMBER OF HERDSMEN, bag, khoroo,and by year
    ## 620                                                                                                                       NUMBER OF HERDER HOUSEHOLDS, bag, khoroo, and by year
    ## 621                                                                                                                       NUMBER OF HERDER HOUSEHOLDS, bag, khoroo, and by year
    ## 622                                                                                                             SOME INDICATORS OF HERDING HOUSEHOLDS, bag, khoroo, and by year
    ## 623                                                                                            GROUPING OF LIVESTOCK, by herder households, aimags and the Capital, and by year
    ## 624                                                                                            NUMBER OF WELL, RESERVOIR AND AQUIFER, by type, bag, khoroo, and by every 3 year
    ## 625                                            THE NUMBER OF OCCUPIED HOUSING, by main types of wall construction materials, region, aimags and the Capital, and by census year
    ## 626                                                                                                              BATHING SERVICE, by regions,aimags and the capital /1994-2019/
    ## 627                                                          NUMBER OF HOUSEHOLDS, by electricity source, region, aimags and the Capital, soum and district, and by census year
    ## 628                                                          NUMBER OF HOUSEHOLDS, by water supply type, region, aimags and the Capital, soum and district, and by census years
    ## 629                                                                                                THE NUMBER OF HOUSES, by type of dwelling, number of room and by census year
    ## 630                                        PROPORTION OF HOUSEHOLDS WITH AND WITHOUT ACCESS TO SANITATION,region, aimags and the Capital, soum and district, and by census year
    ## 631                                                                                      THE NUMBER OF DWELLINGS, by type of dwelling, basic floor material, and by census year
    ## 632                                                                                      HOUSEHOLDS WHO LIVE IN APARTMENT WITH CENTRALIZED AND INDEPENDENT ENGINEERING SYSTEMS,
    ## 633                             HOUSEHOLDS WHO LIVE IN HOUSE,GER AND OTHER DWELLING, by type of dwelling,region, aimags and the Capital, soum and district, and by census years
    ## 634                              2020-2050 POPULATION PROJECTION BASED ON RESIDENT POPULATION OF MONGOLIA, by sex, age group, aimags and the Capital, and by medium scenario 1B
    ## 635                                                      2020-2050 POPULATION PROJECTION BASED ON RESIDENT POPULATION OF MONGOLIA, by sex, age group, and by medium scenario 1B
    ## 636                                                         2020-2050 POPULATION PROJECTION BASED ON TOTAL POPULATION OF MONGOLIA, by sex, age group, and by medium scenario 2B
    ## 637                                                                                         ADMINISTRATIVE AND TERRITORIAL UNITS, by region, aimags and the Capital and by year
    ## 638                                                                                                                                                    MAJOR MOUNTAINS, by year
    ## 639                                                                                                                                                       MAJOR RIVERS, by year
    ## 640                                                                                                                                                         MAJOR LAKE, by year
    ## 641                                                                                                                    SOWN AREAS, by type of crop, soum, district, and by year
    ## 642                                                                                                                HARVESTED CROP, by type of crop, soum, district, and by year
    ## 643                                                                                                           NUMBER OF FARM HOUSEHOLDS, by aimags and the Capital, and by year
    ## 644                                                                                                        NUMBER OF FARMER ENTERPRISES, by aimags and the Capital, and by year
    ## 645                                                CONSTRUCTION, CAPITAL REPAIRS AND MAINTENANCES, by type of construction, aimags and the Capital, and by quarter (cumulative)
    ## 646                                                                          CONSTRUCTION, CAPITAL REPAIRS PERFORMED BY DOMESTIC ENTERPRISES, by soum, district, and by quarter
    ## 647                                                    COMMISSIONED CONSTRUCTION, CAPITAL REPAIRS AND MAINTENANCE, by type of construction, aimags and the Capital, and by year
    ## 648                                                CONSTRUCTION, CAPITAL REPAIRS AND MAINTENANCES, by type of construction, aimags and the Capital, and by quarter (cumulative)
    ## 649                                                                                              NUMBER OF PERSONS WITH DISABILITY, by sex, aimags and the Capital, and by year
    ## 650                                                                                       NUMBER OF PERSONS WITH SEEING DISABILITY, by sex, aimags and the Capital, and by year
    ## 651                                                                                      NUMBER OF PERSONS WITH HEARING DISABILITY, by sex, aimags and the Capital, and by year
    ## 652                                                                                     NUMBER OF PERSONS WITH SPEAKING DISABILITY, by sex, aimags and the Capital, and by year
    ## 653                                                                                     NUMBER OF PERSONS WITH MOBILITY DISABILITY, by sex, aimags and the Capital, and by year
    ## 654                                                                                       NUMBER OF PERSONS WITH MENTAL DISABILITY, by sex, aimags and the Capital, and by year
    ## 655                                                                                  NUMBER OF PERSONS WITH COMBINATION DISABILITY, by sex, aimags and the Capital, and by year
    ## 656                                                                                        NUMBER OF PERSONS WITH OTHER DISABILITY, by sex, aimags and the Capital, and by year
    ## 657                                                                                   FULL-TIME TEACHERS IN GENERAL EDUCATIONAL SCHOOLS, by aimags and the Capital, and by year
    ## 658                                                                                        FULL-TIME TEACHERS IN GENERAL EDUCATIONAL SCHOOLS, by soum and district, and by year
    ## 659                                                                                   FULL-TIME STUDENTS OF GENERAL EDUCATIONAL SCHOOLS, by aimags and the Capital, and by year
    ## 660                                                                                                              GENERAL EDUCATIONAL SCHOOLS, by soum and district, and by year
    ## 661                                                                                   FULL-TIME STUDENTS OF GENERAL EDUCATIONAL SCHOOLS, by aimags and the Capital, and by year
    ## 662                                                                  STUDENTS IN TECHNICAL AND VOCATIONAL EDUCATIONAL INSTITUTIONS, by sex, aimags and the Capital, and by year
    ## 663                                                   EMPLOYEES AND FULL-TIME TEACHERS IN TECHNICAL AND VOCATIONAL EDUCATIONAL INSTITUTIONS, by aimag and the capital, and year
    ## 664                                                                             NUMBER OF FULL-TIME TEACHERS IN PRE-SCHOOL INSTITUTIONS, by aimags and the Capital, and by year
    ## 665                                                                                           EMPLOYEES OF PRE-SCHOOL INSTITUTIONS, by sex, aimags and the Capital, and by year
    ## 666                                                                                                             NUMBER OF KINDERGARTENS, by aimags and the Capital, and by year
    ## 667                                                                                                                  NUMBER OF KINDERGARTENS, by soum and district, and by year
    ## 668                                                                                       NUMBER OF CHILDREN IN PRE-SCHOOL INSTITUTIONS, by aimags and the Capital, and by year
    ## 669                                                                    NUMBER OF STUDENTS IN UNIVERSITIES, INSTITUTES AND COLLEGES, by sex, aimags and the Capital, and by year
    ## 670                                                               GENERAL EDUCATIONAL SCHOOL'S PUPILS, REQUESTED TO LIVE IN DORMITORIES, by aimags and the Capital, and by year
    ## 671                                                                          GENERAL EDUCATIONAL SCHOOL'S PUPILS, LIVING IN DORMITORIES, by aimags and the Capital, and by year
    ## 672                                          STUDENT AND GRADUATES OF VOCATIONAL AND TECHNICAL EDUCATIONAL INSTITUTIONS, by field of study, aimags and the Capital, and by year
    ## 673                                                                                    NUMBER OF NEW ENTRANTS TO GENERAL EDUCATIONAL SCHOOLS, by soum and district, and by year
    ## 674                                                                                          NUMBER OF EMPLOYEES IN PRE-SCHOOLS INSTITUTIONS, by soum and district, and by year
    ## 675                                                                     EVALUATION OF GENERAL ADMISSION EXAM (DIMENSIONAL SCORING), by sex, aimags and the Capital, and by year
    ## 676                                                                         FULL-TIME GRADUATES FROM GENERAL EDUCATIONAL SCHOOLS, by grade, aimags and the Capital, and by year
    ## 677                                                                                        FULL-TIME STUDENTS OF GENERAL EDUCATIONAL SCHOOLS, by soum and district, and by year
    ## 678                                                                                     FULL-TIME GRADUATES FROM GENERAL EDUCATIONAL SCHOOLS, by soum and district, and by year
    ## 679                                                                   STUDENTS WITH DISABILITIES STUDYING IN GENERAL EDUCATIONAL SCHOOLS, by aimag and the Capital, and by year
    ## 680                                                                      NUMBER OF CHILDREN WITH DISABILITIES IN PRE-SCHOOL INSTITUTIONS, by aimag and the Capital, and by year
    ## 681                                                                                                      CHILDREN IN PRE-SCHOOL INSTITUTIONS, by soum and district, and by year
    ## 682                                                                  REPRESENTATIVES OF CITIZENS’ REPRESENTATIVE KHURAL, by sex, age group, aimags and the Capital, and by year
    ## 683                                                                       REPRESENTATIVES OF CITIZENS’ REPRESENTATIVE KHURAL, by sex, age group, soum and district, and by year
    ## 684                                                      REPRESENTATIVES OF CITIZENS’ REPRESENTATIVE KHURAL, by sex, age group, aimags and the capital, and by year (2020-2021)
    ## 685                                                           REPRESENTATIVES OF CITIZENS’ REPRESENTATIVE KHURAL, by sex, age group, soum and district, and by year (2020-2021)
    ## 686                                                                               GRANTS FROM CENTRAL GOVERNMENT TO LOCAL GOVERNMENT, by region, aimag and the Capital, by year
    ## 687                                                                                                         EXPENDITURE OF LOCAL GOVERNMENT, by aimags and the Capital, by year
    ## 688                                                                                                             REVENUE OF LOCAL GOVERNMENT, by aimags and the Capital, by year
    ## 689                                                                                                             HUMAN DEVELOPMENT INDEX, by aimags and the Capital, and by year
    ## 690                                                                                                            GENDER DEVELOPMENT INDEX, by aimags and the Capital, and by year
    ## 691                                                                                                        GENDER INEQUALITY INDEX, by sex, aimags and the Capital, and by year
    ## 692                                                                                                             GENDER INEQUALTIY INDEX, by aimags and the Capital, and by year
    ## 693                                                                                                    HUMAN DEVELOPMENT DIMENSION INDEX, by aimag and the Capital, and by year
    ## 694                                            THE NUMBER OF OCCUPIED HOUSING, by main types of wall construction materials, region, aimags and the Capital, and by census year
    ## 695                                                          NUMBER OF HOUSEHOLDS, by electricity source, region, aimags and the Capital, soum and district, and by census year
    ## 696                                                          NUMBER OF HOUSEHOLDS, by water supply type, region, aimags and the Capital, soum and district, and by census years
    ## 697                                        PROPORTION OF HOUSEHOLDS WITH AND WITHOUT ACCESS TO SANITATION,region, aimags and the Capital, soum and district, and by census year
    ## 698             HOUSEHOLDS WHO LIVE IN APARTMENT WITH CENTRALIZED AND INDEPENDENT ENGINEERING SYSTEMS, by region, aimags and the Capital, soum and district, and by census year
    ## 699                             HOUSEHOLDS WHO LIVE IN HOUSE,GER AND OTHER DWELLING, by type of dwelling,region, aimags and the Capital, soum and district, and by census years
    ## 700                                                                                                      NUMBER OF CRIME-RELATED DEATHS, by region, aimag, and the capital city
    ## 701                                                                                              Recorded crimes, by committed status and regions, aimags and the capital, year
    ## 702                                                                                           Recorded crimes, by committed status and regions, aimags and the capital, monthly
    ## 703                                                                                                                   CRIME CAUSED OF DAMAGES AND DAMAGES WERE RESTITUTED, year
    ## 704                                                                                                 NUMBER OF RECORDED CRIMES, by region, aimag and the capital, year and month
    ## 705                                                                                            NUMBER OF OFFENDERS, by region, aimag and the capital, sex , age group and month
    ## 706                                                                                            NUMBER OF OFFENDERS, by region, aimag and the capital, sex , age group and month
    ## 707                                                                                                                        Injured persons, by region, aimag and capital , year
    ## 708                                                                                               CRIMES AGAINST HUMAN HEALTH IMMUNITY, by region, aimag and the capital, years
    ## 709                                                                                         ENTITIES VICTIMISED, by region, aimag, capital, district, and by legal status, year
    ## 710                                                                                                VICTIMS OF CRIME, by region, aimag, capital the district and age group, year
    ## 711                                                                                                NUMBER OF CONVICTED PERSONS BY COURT, by region, aimag and the capital, year
    ## 712                                                                                               CRIMES AGAINST HUMAN RIGHT TO BE LIVE, by region, aimag and the capital, year
    ## 713                                                                                                CRIMES AGAINST HUMAN HEALTH IMMUNITY, by region, aimag and the capital, year
    ## 714                                                                                               CRIMES AGAINST THE RIGHT OF OWNERSHIP, by region, aimag and the capital, year
    ## 715                                                                                                            CRIME OF LIVESTOCK THEFT, by region, aimag and the capital, year
    ## 716                                                                                                 CRIMES AGAINST PUBLIC SAFETY AND INTEREST, by region, aimag and the capital
    ## 717                                                                                CRIMES AGAINST TRAFFIC SAFETY AND REGULATION OF VEHICLE USE by region, aimag and the capital
    ## 718                                                                                                                     ECONOMIC CRIMES, by aimags and the Capital, and by year
    ## 719                                                                                                                                   LAWYERS, by region, aimag and the capital
    ## 720                                                                                                        RECORDED ACCIDENTS OF ROAD TRAFFIC, by region, aimag and the capital
    ## 721                                                                                           RECORDED CRIMES, by committed status and regions, aimags and the capital, monthly
    ## 722                                                                                                              RECORDED VIOLATION, by regions,aimags and the capital, monthly
    ## 723                                                                                              LABOUR DISPUTE CASES RESOLVED BY COURT, by region, aimag and the capital, year
    ## 724                                                                                                             SURVIVALS OF YOUNG ANIMALS, aimags and the Capital, and by year
    ## 725                                                                                              NUMBER OF LIVESTOCK, by type of livestock, aimags and the Capital, and by year
    ## 726                                                                                                                     NUMBER OF HERDSMEN, aimags and the Capital, and by year
    ## 727                                                                                      NUMBER OF LIVESTOCK DIED FROM DISAESES, by type of livestock, bag, khoroo, and by year
    ## 728                                                                                                       NUMBER OF HERDER HOUSEHOLDS, aimags and the Capital city, and by year
    ## 729                                                                                                       NUMBER OF HERDER HOUSEHOLDS, aimags and the Capital city, and by year
    ## 730                                                                                                                          NUMBER OF YAK, aimags and the Capital, and by year
    ## 731                                                                                                    NUMBER OF DOMESTIC ANIMALS, by type, aimags and the Capital, and by year
    ## 732                                                                                                    NUMBER OF MISCARRAGE FEMALE ANIMALS, aimags and the Capital, and by year
    ## 733                                                                                   NUMBER OF BARREN FEMALE ANIMALS, by type of livestock, aimag and the Capital, and by year
    ## 734                                                                                         NUMBER OF BREEDING STOCK, by type of livestock, aimags and the Capital, and by year
    ## 735                                                                                          LOSSES OF ADULT ANIMALS, by type of livestock, aimags and the Capital, and by year
    ## 736                                                                                              TEMPLES AND CHURCHES, by type of religion, aimags and the Capital, and by year
    ## 737                                                                                            MONKS AND MISSIONARIES, by type of religion, aimags and the Capital, and by year
    ## 738                                                               STUDENTS STUDYING IN RELIGIOUS SCHOOLS AND COLLEGES, by type of religion, aimags and the Capital, and by year
    ## 739                                                                                                           LOANS OUTSTANDING, by region, aimag and the Capital city, by year
    ## 740                                                                                                      OUTSTANDING INDIVIDIAL DEPOSITS, by region, aimag and Capital, by year
    ## 741                                                                                                 OUTSTANDING NON-PERFORMING LOANS, by region, aimag and the Capital, by year
    ## 742                                                                                                              GROSS DOMESTIC PRODUCT, by aimags and the Capital, and by year
    ## 743                                                                                                   GROSS DOMESTIC PRODUCT PER CAPITA, by aimags and the Capital, and by year
    ## 744                                                                                                       GROSS FIXED CAPITAL FORMATION, by aimags and the Capital, and by year
    ## 745                                                                                    INDUSTRIAL COMPOSITION OF GROSS DOMESTIC PRODUCT, by aimags and the Capital, and by year
    ## 746                                                                                           GROSS DOMESTIC PRODUCT, by economic activity, aimags and the Capital, and by year
    ## 747                                                                                                             STATE BUDGET INVESTMENT, by aimags and the Capital, and by year
    ## 748                                                                                                             LOCAL BUDGET INVESTMENT, by aimags and the Capital, and by year
    ## 749                                                                                                             MID-YEAR RESIDENT POPULATION, by soum and district, and by year
    ## 750                                                                                                    POPULATION OF MONGOLIA, by location, aimags and the Capital, and by year
    ## 751                                                                                                          RESIDENT POPULATION IN MONGOLIA, by soum and district, and by year
    ## 752                                                                                                                     NUMBER OF HOUSEHOLDS, by soum and discrict, and by year
    ## 753                                                                                                           NUMBER OF HOUSEHOLDS, by location, soum and discrict, and by year
    ## 754                                                                                                                    NUMBER OF DEATHS, by sex, soum and district, and by year
    ## 755                                                                                                                    NUMBER OF BIRTHS, by sex, soum and discrict, and by year
    ## 756                                                                                                              NUMBER OF DEATHS, by age group, soum and district, and by year
    ## 757                                                                                                         NUMBER OF MARRIAGES AND DIVORCES, by soum and district, and by year
    ## 758                                                                                                                REGISTERED MARRIAGES, by sex, soum and district, and by year
    ## 759                                                                                         MARRIAGES AND DIVORCES, by per 1000 population, aimags and the Capital, and by year
    ## 760                                                                                                     NUMBER OF BIRTHS, by mother's age group, soum and discrict, and by year
    ## 761                                                                                                                      DEATH PER 1000, by sex, soum and district, and by year
    ## 762                                                                                                                         CRUDE BIRTH RATE, by soum and district, and by year
    ## 763                                                                                                       LIFE EXPECTANCY AT BIRTH, by sex, aimags and the Capital, and by year
    ## 764                                                                                                                       SEX RATIO AT BIRTH, by soum and discrict, and by year
    ## 765                                                                                                                                  DENSITY, by soum and discrict, and by year
    ## 766                                                                                                                         DEPENDENCY RATIO, by soum and district, and by year
    ## 767                                                                                         WOMEN WHO GAVE BIRTH, by mother's educational level, soum and district, and by year
    ## 768                                                                                                                POPULATION MIGRATION, by aimags and the Capital, and by year
    ## 769                                                                                                     WOMEN WHO GAVE BIRTH, by marital status, soum and district, and by year
    ## 770                                                                                                                                 ADOPTION, by soum and district, and by year
    ## 771                                                                                               RESIDENT POPULATION IN MONGOLIA, by age group, soum and district, and by year
    ## 772                                                                                                  RESIDENT POPULATION IN MONGOLIA, by sex, by soum and district, and by year
    ## 773                                                                                                    MONTHLY AVERAGE INCOME PER HOUSEHOLD, by region, and by year /2007-2024/
    ## 774                                                                                               MONTHLY AVERAGE EXPENDITURE PER HOUSEHOLD, by region, and by year /2007-2024/
    ## 775                                                                                     COMPOSITION OF MONTHLY AVERAGE INCOME PER HOUSEHOLD, by region, and by year /2007-2024/
    ## 776                                                                                COMPOSITION OF MONTHLY AVERAGE EXPENDITURE PER HOUSEHOLD, by region, and by year /2007-2024/
    ## 777                                            INEQUALITY, based on monthly consumption per capita, by region, and by year /Gini coefficient and Theil index, by every 2 years/
    ## 778                                                                             CONSUMER PRICE INDEX, compared with the previous month, by aimags and the Capital, and by month
    ## 779                                                      CONSUMER PRICE INDEX, compared with the same period of the previous year, by aimags and the Capital city, and by month
    ## 780                                                                   CONSUMER PRICE INDEX, compared with the end of the previous year, by aimags and the Capital, and by month
    ## 781                                                                                                                      NATIONAL BASE CONSUMER PRICE INDEX, by group and month
    ## 782                                                                                                                                NATIONAL CONSUMER PRICE INDEX, 1991-1-16=100
    ## 783                                                                         NATIONAL CONSUMER PRICE INDEX, by groups and percent changes compared with the end of previous year
    ## 784                                                                                                             NATIONAL CONSUMER PRICE INDEX, by group, monthly percent change
    ## 785                                                                NATIONAL CONSUMER PRICE INDEX, by groups and percent changes, compared with the same period of previous year
    ## 786                                                                                                                                                              INFLATION RATE
    ## 787                                                                        SMALL AND MEDIUM-SIZED ENTERPRISES VALUE ADDED SHARES IN GDP, by aimags and the Capital, and by year
    ## 788                                                                                               SMALL AND MEDIUM-SIZED LEGAL ENTITIES, by aimags and the Capital, and by year
    ## 789                                                                        REGISTERED COOPERATIVES, MEMBER IN THE BUSINESS REGISTER DATABASE, by soum and district, and by year
    ## 790                                                             REGISTERED COOPERATIVES STAKEHOLDER’S CAPITAL THE BUSINESS REGISTER DATABASE, by soum and district, and by year
    ## 791                                                                                              NUMBER OF LEGAL ENTITIES, by soum, district and ownership type, and by quarter
    ## 792                                                                                       NUMBER OF LEGAL ENTITIES, by employment size class, soum and district, and by quarter
    ## 793                                                         NUMBER OF LEGAL ENTITIES REGISTERED IN THE BUSINESS REGISTRY, by activity status, soum and district, and by quarter
    ## 794                                                                                        NUMBER OF LEGAL ENTITIES, by type of legal status, soum and district, and by quarter
    ## 795                                                                               NUMBER OF LEGAL ENTITIES, by section of economic activiies, soum and district, and by quarter
    ## 796                                                                                         ADMINISTRATIVE AND TERRITORIAL UNITS, by region, aimags and the Capital and by year
    ## 797                                                                                                                   TOTAL TRADE TURNOVER, by aimags and Capital, and by month
    ## 798                                                                                                                                                       TOTAL TRADE TURNOVER,
    ## 799                                                                                                                                                  INCOME OF THE HOTEL SECTOR
    ## 800                                                                                                                                                  INCOME OF THE HOTEL SECTOR
    ## 801                                                                                                                                                  “INCOME OF THE FOOD SECTOR
    ## 802                                                                                                                                                   INCOME OF THE FOOD SECTOR
    ## 803                                                                                                             KEY INDICATORS OF AUTO TRANSPORT, by national level and quarter
    ## 804                                                                                                     KEY INDICATORS OF TRANSPORTATION SECTOR, by national level, and by year
    ## 805                                                                                                       CARRIED PASSENGERS, by each direction, by national level and by month
    ## 806                                                                                                            KEY INDICATORS OF AIR TRANSPORT, by national level, and by month
    ## 807                                                                                                         KEY INDICATORS OF RAILWAY TRANSPORT, by national level and by month
    ## 808                                                 NUMBER OF VEHICLES PASSED THE TECHNICAL INSPECTION, by type, region, aimags and the Capital, soum and district, and by year
    ## 809                                                  NUMBER OF VEHICLES PASSED THE TECHNICAL INSPECTION, by age, region, aimags and the Capital, soum and district, and by year
    ## 810                                                                                         NUMBER OF REGISTERED VEHICLES, by type, region, aimags and the Capital, and by year
    ## 811                                                                                          NUMBER OF REGISTERED VEHICLES, by age, region, aimags and the Capital, and by year
    ## 812                                                                                                       NUMBER OF IMPORTED VEHICLES, by country, type of vehicle, and by year
    ## 813                                                                                         NUMBER OF CABLE TELEVISION USERS, by region, aimags and the Capital, and by quarter
    ## 814                                                                                   NUMBER OF INTERNET USERS AND COMPUTERS, by region, aimags and the Capital, and by quarter
    ## 815                                                                                 KEY INDICATORS OF COMMUNICATION SERVICES, by region, aimags and the Capital, and by quarter
    ## 816                                                                                                                         POSTAL SERVICE INDICATORS, by types, and by quarter
    ## 817                                                                       REVENUE OF COMMUNICATION SECTOR, by type of operation, region, aimags and the Capital, and by quarter
    ## 818                                                                                              NUMBER OF PERSONS WITH DISABILITY, by sex, aimags and the Capital, and by year
    ## 819                                                                                                                                  NUMBER OF PERSONS WITH DISABILITY, by type
    ## 820                                                                                       NUMBER OF PERSONS WITH SEEING DISABILITY, by sex, aimags and the Capital, and by year
    ## 821                                                                                      NUMBER OF PERSONS WITH HEARING DISABILITY, by sex, aimags and the Capital, and by year
    ## 822                                                                                     NUMBER OF PERSONS WITH SPEAKING DISABILITY, by sex, aimags and the Capital, and by year
    ## 823                                                                                     NUMBER OF PERSONS WITH MOBILITY DISABILITY, by sex, aimags and the Capital, and by year
    ## 824                                                                                       NUMBER OF PERSONS WITH MENTAL DISABILITY, by sex, aimags and the Capital, and by year
    ## 825                                                                                  NUMBER OF PERSONS WITH COMBINATION DISABILITY, by sex, aimags and the Capital, and by year
    ## 826                                                                                        NUMBER OF PERSONS WITH OTHER DISABILITY, by sex, aimags and the Capital, and by year
    ## 827                                                                                                    ELECTION RESULTS OF THE PRESIDENT OF MONGOLIA (during the election year)
    ## 828                                                     MEMBERS OF THE PARLIAMENT AND REPRESENTATIVES OF THE CITIZENS REPRESENTATIVE KHURAL, parties (during the election year)
    ## 829                                                                                                                      PARTICIPATION OF ELECTIONER (during the election year)
    ## 830                                                                                          MEMBERS OF PARLIAMENT OF MONGOLIA, by sex and age group (during the election year)
    ## 831                                                                                 MEMBERS OF PARLIAMENT OF MONGOLIA, by profession, share to total (during the election year)
    ## 832                                                                               ANNUAL FOOD CONSUMPTION OF STANDARD POPULATION, by national average, product type and by year
    ## 833                                                                                                         LEVEL OF FOOD SUPPLY, by national average, product type and by year
    ## 834                                                         NATIONAL AVERAGE FOR DAILY DIETARY CALORIES INTAKE FOR STANDARD PERSON DURING COLD SEASONS, by location and by year
    ## 835                                                         NATIONAL AVERAGE FOR DAILY DIETARY CALORIES INTAKE FOR STANDARD PERSON DURING WARM SEASONS, by location and by year
    ## 836                                                                                                                      FOOD SUPPLY LEVEL, by source, product type and by year
    ## 837                                                                                                                     FOOD ACCESSIBILITY, by season, product type and by year
    ## 838                                                                                         PREVALENCE OF FOOD INSECURITY, by household, national average, location and by year
    ## 839                                                                                        PREVALENCE OF FOOD INSECURITY, by population, national average, location and by year
    ## 840                                                                  REPRESENTATIVES OF CITIZENS’ REPRESENTATIVE KHURAL, by sex, age group, aimags and the Capital, and by year
    ## 841                                                                       REPRESENTATIVES OF CITIZENS’ REPRESENTATIVE KHURAL, by sex, age group, soum and district, and by year
    ## 842                                                      REPRESENTATIVES OF CITIZENS’ REPRESENTATIVE KHURAL, by sex, age group, aimags and the capital, and by year (2020-2021)
    ## 843                                                           REPRESENTATIVES OF CITIZENS’ REPRESENTATIVE KHURAL, by sex, age group, soum and district, and by year (2020-2021)
    ## 844                                                                                 PROPORTION OF WOMEN WHO HAVE EXPERIENCED VIOLENCE IN THE LAST 12 MONTHS, аge15-49 and 15-64
    ## 845                                            PROPORTION OF WOMEN WHO HAVE EXPERIENCED VIOLENCE IN THE LAST 12 MONTHS, Aged 15-49 and 15-64, by type of violence and age group
    ## 846                                                                                                                   NON-PARTNERED VIOLENCE, by type of violence and age group
    ## 847                                                                                                                    NON-PARTNERED VIOLENCE, by type of violence, perpetrator
    ## 848                                                                                                                      NON-PARTNERED VIOLENCE, by type of violence, frequency
    ## 849                                                                                                                  EVER-PARTNERED VIOLENCE, by type of violence and age group
    ## 850                                                                                                            EVER-PARTNERED VIOLENCE, by type of violence, partnership status
    ## 851                                                                                                                     EVER-PARTNERED VIOLENCE, by type of violence, frequency
    ## 852                                                                                                                                                 TOTAL WOMEN, by urban rural
    ## 853                                                                                                                              TOTAL WOMEN, by region, aimags and the capital
    ## 854                                                                                                                                                   TOTAL WOMEN, by age group
    ## 855                                                                                                                                             TOTAL WOMEN, by education level
    ## 856                                                                                                                                                    TOTAL WOMEN, by location
    ## 857                                                                        EVER-PARTNERED WOMEN WHO HAVE EXPERIENCED VIOLENCE IN LIFETIME, by type of violence, urban and rural
    ## 858                                                                               EVER-PARTNERED WOMEN WHO HAVE EXPERIENCED VIOLENCE IN LIFETIME, by type of violence, location
    ## 859                                                         EVER-PARTNERED WOMEN WHO HAVE EXPERIENCED VIOLENCE IN LIFETIME, by type of violence, region, aimags and the capital
    ## 860                                                                             EVER-PARTNERED WOMEN WHO HAVE EXPERIENCED VIOLENCE IN LIFETIME, by type of violence, age groups
    ## 861                                                                                          EVER-PARTNERED WOMEN WHO HAVE EXPERIENCED VIOLENCE IN LIFETIME, by education level
    ## 862                                                        EVER-PARTNERED WOMEN WHO HAVE EXPERIENCED VIOLENCE IN CURRENT (LAST 12 MONTHS), by type of violence, urban and rural
    ## 863                                                               EVER-PARTNERED WOMEN WHO HAVE EXPERIENCED VIOLENCE IN CURRENT (LAST 12 MONTHS), by type of violence, location
    ## 864                                        EVER-PARTNERED WOMEN WHO HAVE EXPERIENCED VIOLENCE IN CURRENT (LAST 12 MONTHS), by type of violence, regions, aimags and the capital
    ## 865                                                             EVER-PARTNERED WOMEN WHO HAVE EXPERIENCED VIOLENCE IN CURRENT (LAST 12 MONTHS), by type of violence, age groups
    ## 866                                                        EVER-PARTNERED WOMEN WHO HAVE EXPERIENCED VIOLENCE IN CURRENT (LAST 12 MONTHS), by type of violence, education level
    ## 867                                                                                                  MONTHLY AVERAGE INCOME PER HOUSEHOLD, by location, and by year /1997-2024/
    ## 868                                                                                                    MONTHLY AVERAGE INCOME PER HOUSEHOLD, by region, and by year /2007-2024/
    ## 869                                                                                             MONTHLY AVERAGE EXPENDITURE PER HOUSEHOLD, by location, and by year /1997-2024/
    ## 870                                                                                               MONTHLY AVERAGE EXPENDITURE PER HOUSEHOLD, by region, and by year /2007-2024/
    ## 871                                                                                   COMPOSITION OF MONTHLY AVERAGE INCOME PER HOUSEHOLD, by location, and by year /1997-2024/
    ## 872                                                                                     COMPOSITION OF MONTHLY AVERAGE INCOME PER HOUSEHOLD, by region, and by year /2007-2024/
    ## 873                                                                              COMPOSITION OF MONTHLY AVERAGE EXPENDITURE PER HOUSEHOLD, by location, and by year /1997-2024/
    ## 874                                                                                COMPOSITION OF MONTHLY AVERAGE EXPENDITURE PER HOUSEHOLD, by region, and by year /2007-2024/
    ## 875                                                                        MONTHLY AVERAGE PER CAPITA CONSUMPTION OF SOME FOODSTUFF, by adult equivalent, location, and by year
    ## 876                                                              COMPOSITION OF DAILY FOODSTUFF CONSUMPTION AND CALORIES PER CAPITA, by adult equivalent, location, and by year
    ## 877                                                                                          ANNUAL AVERAGE MONETARY INCOME PER HOUSEHOLD, by location, and by year /1966-1996/
    ## 878                                                                                     ANNUAL AVERAGE MONETARY EXPENDITURE PER HOUSEHOLD, by location, and by year /1966-1996/
    ## 879                                                                                                           MONTHLY AVERAGE INCOME PER HOUSEHOLD, by location, and by quarter
    ## 880                                                                                                      MONTHLY AVERAGE EXPENDITURE PER HOUSEHOLD, by location, and by quarter
    ## 881                                                                                            COMPOSITION OF MONTHLY AVERAGE INCOME PER HOUSEHOLD, by location, and by quarter
    ## 882                                                                                       COMPOSITION OF MONTHLY AVERAGE EXPENDITURE PER HOUSEHOLD, by location, and by quarter
    ## 883                                                                          MONETARY INCOME AND EXPENDITURE GROUPING, share to total of household, by location, and by quarter
    ## 884                                                                          MONETARY INCOME GROUPING, share to total of household, by location, at current prices, and by year
    ## 885                                                                     MONETARY EXPENDITURE GROUPING, share to total of household, by location, at current prices, and by year
    ## 886                                                                                                         GINI INDEX, based on monthly expenditure per capita, and by quarter
    ## 887                                                                                                        THEIL INDEX, based on monthly expenditure per capita, and by quarter
    ## 888                                                                                                             HUMAN DEVELOPMENT INDEX, by aimags and the Capital, and by year
    ## 889                                                                                         INEQUALITY-ADJUSTED HUMAN DEVELOPMENT INDEX, by aimags and the Capital, and by year
    ## 890                                                                                                            GENDER DEVELOPMENT INDEX, by aimags and the Capital, and by year
    ## 891                                                                                                        GENDER INEQUALITY INDEX, by sex, aimags and the Capital, and by year
    ## 892                                                                                                          GENDER EMPOWERMENT MEASURE, by aimags and the Capital, and by year
    ## 893                                                                                                             GENDER INEQUALTIY INDEX, by aimags and the Capital, and by year
    ## 894                                                                                                    HUMAN DEVELOPMENT DIMENSION INDEX, by aimag and the Capital, and by year
    ## 895                                                                                                     NUMBER OF CRIME-RELATED DEATHS, by aimags, and the Capital, and by year
    ## 896                                                                                 CRIME CAUSED OF DAMAGES AND DAMAGES WERE RESTITUTED, by aimags and the Capital, and by year
    ## 897                                                                                       PROCESSING AND RESOLUTION OF PETITIONS, COMPLAINTS, AND INFORMATION REQUESTS, by year
    ## 898                                                                                                        REPORT ON DECLARATION OF PRIVATE INTEREST, ASSET AND INCOME, by year
    ## 899                                                                                                                   NUMBER OF CONVICTED PERSONS BY COURT, by sex, and by year
    ## 900                                                                                                NUMBER OF RECORDED CRIMES, by classification, soum and district, and by year
    ## 901                                                                                                                    VICTIMS OF CRIME, by sex, soum and district, and by year
    ## 902                                                                         CRIME CAUSED DAMAGE AND DAMAGES WERE RESTITUED, by type of property, soum and district, and by year
    ## 903                                                                                                                     INJURED PERSONS, by aimags and the Capital, and by year
    ## 904                                                                                                CRIMES AGAINST HUMAN HEALTH IMMUNITY, by aimags and the Capital, and by year
    ## 905                                                                                                        ENTITIES VICTIMISED, by legal status, aimag and Capital, and by year
    ## 906                                                                                                              VICTIMS OF CRIME, by age group, aimag and Capital, and by year
    ## 907                                                                                                NUMBER OF CONVICTED PERSONS BY COURT, by aimags and the Capital, and by year
    ## 908                                                                                               CRIMES AGAINST HUMAN RIGHT TO BE LIVE, by aimags and the Capital, and by year
    ## 909                                                                                                CRIMES AGAINST HUMAN HEALTH IMMUNITY, by aimags and the Capital, and by year
    ## 910                                                                                               CRIMES AGAINST THE RIGHT OF OWNERSHIP, by aimags and the Capital, and by year
    ## 911                                                                                                            CRIME OF LIVESTOCK THEFT, by aimags and the Capital, and by year
    ## 912                                                                                           CRIMES AGAINST PUBLIC SAFETY AND INTEREST, by aimags and the Capital, and by year
    ## 913                                                                         CRIMES AGAINST TRAFFIC SAFETY AND REGULATION OF VEHICLE USE, by aimags and the Capital, and by year
    ## 914                                                                                                                     ECONOMIC CRIMES, by aimags and the Capital, and by year
    ## 915                                                                                                                                     REPORT OF FIRST INSTANCE COURT, by year
    ## 916                                                                                                                                      REPORT OF THE COURT OF APPEAL, by year
    ## 917                                                                                                                        REPORT OF THE COURT OF SUPERVISORY INSTANCE, by year
    ## 918                                                                          RECORDED CRIME RATE PER 10000 POPULATION AGED 16 AND ABOVE, by aimags and the Capital, and by year
    ## 919                                                                                                                 VICTIMS, by sex, age group, and types of crime, and by year
    ## 920                                                         RESOLVED BY COURT CRIMINAL CASE RATE PER 10000 POPULATION AGED 16 AND ABOVE, by aimags and the Capital, and by year
    ## 921                                                                                                                             LAWYERS, by aimags and the Capital, and by year
    ## 922                                                                                                                                     LAWYERS, by sex, occupation, and by sex
    ## 923                                                                                                             CONVICTED PERSONS BY COURT, by types of punishment, and by year
    ## 924                                                                                                                                          LAWYERS, by age group, and by year
    ## 925                                                                                                                                 LAWYERS, by educational degree, and by year
    ## 926                                                                                                                         LAWYERS PASSED THE LEGAL PROFESSIONAL EXAM, by year
    ## 927                                                                                                                         OFFENDERS OF CRIMES, by types of crime, and by year
    ## 928                                                                                                  RECORDED ACCIDENTS OF ROAD TRAFFIC, by aimags and the Capital, and by year
    ## 929                                                                  FROM CAUSED BY ACCIDENTS OF ROAD TRAFFIC, DIED AND INJURED PERSONS, by aimags and the Capital, and by year
    ## 930                                                                                  DIED PERSONS, FROM CAUSED BY ACCIDENTS OF ROAD TRAFFIC, by aimags and Capital, and by year
    ## 931                                                                                                                             RESOLVED CRIMES, by type of crimes, and by year
    ## 932                                                                                                                      RESOLVED CRIME ACCORDING TO THE LAW ON FAMILY, by year
    ## 933                                                                                                                                          SETTLEMENT OF CHILD CRANT, by year
    ## 934                                                                                                                     SETTLEMENT OF CHILD CRANT, by form payment, and by year
    ## 935                                                                                     RECORDED CRIMES, by committed status, and aimags and the Capital, by month (cumulative)
    ## 936                                                                                                        RECORDED VIOLATION, by aimags and the Capital, by month (cumulative)
    ## 937                                                                                                             RECODED CRIME, by type of crime, soum and district, and by year
    ## 938                                                                                              LABOUR DISPUTE CASES RESOLVED BY COURT, by aimags and the Capital, and by year
    ## 939                                                                                                                                                      POVERT HEADCOUNT RATIO
    ## 940                                                                                                                                          POVERTY HEADCOUNT RATIO, by region
    ## 941                                                                                                                             POVERTY GAP RATIO, BY URBAN, rural and location
    ## 942                                                                                                                                                POVERTY GAP RATIO, by region
    ## 943                                                                                                                           SHARE OF POOREST QUINTILE IN NATIONAL CONSUMPTION
    ## 944                                                                                                                                                              PER CAPITA GDP
    ## 945                                                                                                                  LABOUR FORCE PARTICIPATION RATE, by aimags and the Capital
    ## 946                                                                                                              UNEMPLOYMENT RATE OF 15-24 YEAR-OLDS, by aimag and the Capital
    ## 947                                                                                             NET ENROLMENT RATIO IN PRIMARY EDUCATION, by aimags and the Capital, by percent
    ## 948                                                                                          PROPORTION OF PUPILS STARTING GRADE 1 WHO REACH GRADE 5, by aimags and the Capital
    ## 949                                                                                                                 LITERACY RATE OF 15-24 YEAR-OLDS, by aimags and the Capital
    ## 950                                                                                                      RATIO OF GIRLS TO BOYS IN PRIMARY EDUCATION, by aimags and the Capital
    ## 951                                                                                                    RATIO OF GIRLS TO BOYS IN SECONDARY EDUCATION, by aimags and the Capital
    ## 952                                                                                           RATIO OF FEMALE TO MALE STUDENTS IN TERTIARY EDUCATION, by aimags and the Capital
    ## 953                                                                                  SHARE OF WOMEN IN WAGE EMPLOYMENT IN THE NON-AGRICULTURAL SECTOR by aimags and the Capital
    ## 954                                                                                                     PROPORTION OF SEATS HELD BY WOMEN IN THE STATE GREAT HURAL [PARLIAMENT]
    ## 955                                                                                        PROPORTION OF WOMEN CANDIDATES IN PARLIAMENTARY ELECTIONS, by aimags and tha Capital
    ## 956                                                                                                                              UNDER-FIVE MORTALITY RATE PER 1000 LIVE BIRTHS
    ## 957                                                                                                                                  INFANT MORTALITY RATE PER 1000 LIVE BIRTHS
    ## 958                                                                                                                PROPORTION OF UNDER AGE 1 CHILDREN IMMUNISED AGAINST MEASLES
    ## 959                                                                                                   MATERNAL MORTALITY RATIO PER 100000 LIVE BIRTHS, by aimag and the Capital
    ## 960                                                                                        PROPORTION OF BIRTHS ATTENDED BY SKILLED HEALTH PERSONNEL, by aimags and the Capital
    ## 961                                                                                                                                         HIV PREVALENCE AMONG PREGNANT WOMEN
    ## 962                                                                                                                            HIV PREVALENCE AMONG POPULATION AGED 15-24 YEARS
    ## 963                                                                                                        PREVALENCE TUBERCULOSIS PER 100000 PERSON, by aimags and the Capital
    ## 964                                                                                                      INCIDENCE OF TUBERCULOSIS PER 100000 PERSON, by aimags and the Capital
    ## 965                                                                                       DEATH RATES ASSOCIATED WITH TUBERCULOSIS PER 100000 PERSON, by aimags and the Capital
    ## 966                                        PROPORTION OF TUBERCULOSIS CASES DETECTED AND CURED UNDER DIRECTLY-OBSERVED TREATMENT SHORT COURSE (DOTS), by aimags and the Capital
    ## 967                                                                                                                        PROPORTION OF FOREST AREA, by aimags and the Capital
    ## 968                                                                                                             PROPORTION OF SPECIAL PROTECTED AREA, by aimags and the Capital
    ## 969                                                                                                                             CARBON DIOXIDE EMISSIONS PER CAPITA, ton/person
    ## 970                                                                   AVERAGE DAILY CONCENTRATION OF NITROGEN DIOXIDE IN THE ATMOSPHERE OF ULAANBAATAR IN WINTER PERIOD, mkg/m3
    ## 971                                                                         AVERAGE CONCENTRATION OF SULPHURE DIOXIDE IN THE ATMOSPHERE OF ULAANBAATAR IN WINTER PERIOD, mkg/m3
    ## 972                                                                                                                               PROPORTION OF PROTECTED SURFACE WATER SOURCES
    ## 973                                                                                                                         NUMBER OF PROTECTED AND REHABILITATED WATER SOURCES
    ## 974                                                                           PROPORTION OF POPULATION WITHOUT ACCESS TO SAFE DRINKING WATER SOURCES, by aimags and the Capital
    ## 975                                                                        PROPORTION OF POPULATION WITHOUT ACCESS TO IMPROVED SANITATION FACILITIES, by aimags and the Capital
    ## 976  PROPORTION OF POPULATION LIVING IN HOUSES AND APARTMENTS WITH CONNECTIONS TO ENGINEERING SERVICE NETWORKS (ELECTRICITY, WATER, SEWAGE AND HEAT), by aimags and the Capital
    ## 977                                                                                   PROPORTION OF OFFICIAL DEVELOPMENT ASSISTANCE (ODA) PROVIDED TO HELP BUILD TRADE CAPACITY
    ## 978                                                                                                                                  PROPORTION OF ODA TO BASIC SOCIAL SERVICES
    ## 979                                                                                                                        PERCENTAGE OF EXPORT IN GROSS DOMESTIC PRODUCT (GDP)
    ## 980                                                                                                                          FINANCIAL DEEPENING (RATIO OF MONEY SUPPLY TO GDP)
    ## 981                                                                                                                                  PROPORTION OF ODA IN GROSS NATIONAL INCOME
    ## 982                                                                                                                     PROPORTION OF TRANSIT FREIGHT IN RAILWAY TRANSPORTATION
    ## 983                                                                                                                               PROPORTION OF GOVERNMENT EXTERNAL DEBT IN GDP
    ## 984                                                                                                                            PROPORTION OF GOVERNMENT EXTERNAL DEBT IN EXPORT
    ## 985                                                                                                                           PROPORTION OF EXTERNAL DEBT IN GOVERNMENT REVENUE
    ## 986                                                                                           GOVERNMENT EXTERNAL DEBT SERVICE AS A PERCENTAGE OF EXPORTS OF GOODS AND SERVICES
    ## 987                                                                                                                   PROPORTION OF EXTERNAL DEBT SERVICE IN GOVERNMENT REVENUE
    ## 988                                                                                                                                         TELEPHONE LINES PER 1000 POPULATION
    ## 989                                                                                                                                          INTERNET USERS PER 1000 POPULATION
    ## 990                                                                                                                                    CELLULAR SUBSCRIBERS PER 1000 POPULATION
    ## 991                                                                                                                          HUMAN DEVELOPMENT INDEX, by aimags and the Capital
    ## 992                                                                                                                            IMPLEMENTATION/ENFORCEMENT OF JUDICIAL DECISIONS
    ## 993                                                                             NUMBER OF ATTORNEYS THAT PROVIDE SERVICES TO CITIZENS WHO ARE NOT ABLE TO PAY FOR SUCH SERVICES
    ## 994                                                              NUMBER OF STATE ORGANIZATIONS THAT REGULARLY PLACE REPORTS OF THEIR BUDGETS AND EXPENDITURES ON THEIR WEBSITES
    ## 995                                NUMBER OF CIVIL SOCIETY ORGANIZATIONS THAT HAVE OFFICIALLY EXPRESSED THEIR VIEWS IN THE PROCESS OF DEVELOPING AND APPROVING THE STATE BUDGET
    ## 996                                                                                                                              INDEX OF CORRUPTION, by aimags and the Capital
    ## 997                                                                              PERCEPTION OF CORRUPTION IN POLITICAL ORGANIZATIONS, JUDICIAL AND LAW ENFORCEMENT INSTITUTIONS
    ## 998                                                                                      PREVALENCE OF UNDERWEIGHT CHILDREN UNDER AGE FIVE, by urban and rural with soum center
    ## 999                                                                                                                                DIAL-1 Trade union density rate (percentage)
    ## 1000                                                                                                                                              CONTRACEPTIVE PREVALENCE RATE
    ## 1001                                                                                                            PREVALENCE OF UNDERWEIGHT CHILDREN UNDER AGE FIVE, by age group
    ## 1002                                                                                                              PREVALENCE OF UNDERWEIGHT CHILDREN UNDER AGE FIVE, by regions
    ## 1003                                                                                                             PREVALENCE OF UNDERWEIGHT CHILDREN UNDER AGE FIVE, by location
    ## 1004                                                                                           PREVALENCE OF UNDERWEIGHT CHILDREN UNDER AGE FIVE, by mother's educational level
    ## 1005                                                                                                            PREVALENCE OF UNDERWEIGHT CHILDREN UNDER AGE FIVE, by quintiles
    ## 1006                                                                       PREVALENCE OF STUNTING /HEIGHT FOR AGE/ CHILDREN UNDER AGE FIVE, by urban and rural with soum center
    ## 1007                                                                                                    PREVALENCE OF STUNTING /HEIGHT FOR AGE/ CHILDREN UNDER AGE FIVE, by sex
    ## 1008                                                                                              PREVALENCE OF STUNTING /HEIGHT FOR AGE/ CHILDREN UNDER AGE FIVE, by age group
    ## 1009                                                                                                 PREVALENCE OF STUNTING /HEIGHT FOR AGE/ CHILDREN UNDER AGE FIVE, by region
    ## 1010                                                                                               PREVALENCE OF STUNTING /HEIGHT FOR AGE/ CHILDREN UNDER AGE FIVE, by location
    ## 1011                                                                             PREVALENCE OF STUNTING /HEIGHT FOR AGE/ CHILDREN UNDER AGE FIVE, by mother's educational level
    ## 1012                                                                                              PREVALENCE OF STUNTING /HEIGHT FOR AGE/ CHILDREN UNDER AGE FIVE, by quintiles
    ## 1013                                                                     PREVALENCE OF WASTING /WEIGHT FOR HEIGHT/ CHILDREN UNDER AGE FIVE, by urban and rural with soum center
    ## 1014                                                                                                  PREVALENCE OF WASTING /WEIGHT FOR HEIGHT/ CHILDREN UNDER AGE FIVE, by sex
    ## 1015                                                                                            PREVALENCE OF WASTING /WEIGHT FOR HEIGHT/ CHILDREN UNDER AGE FIVE, by age group
    ## 1016                                                                                               PREVALENCE OF WASTING /WEIGHT FOR HEIGHT/ CHILDREN UNDER AGE FIVE, by region
    ## 1017                                                                                             PREVALENCE OF WASTING /WEIGHT FOR HEIGHT/ CHILDREN UNDER AGE FIVE, by location
    ## 1018                                                                           PREVALENCE OF WASTING /WEIGHT FOR HEIGHT/ CHILDREN UNDER AGE FIVE, by mother's educational level
    ## 1019                                                                                            PREVALENCE OF WASTING /WEIGHT FOR HEIGHT/ CHILDREN UNDER AGE FIVE, by quintiles
    ## 1020                                                                                             TEMPLES AND CHURCHES, by type of religion, aimags and the Capital, and by year
    ## 1021                                                                                           MONKS AND MISSIONARIES, by type of religion, aimags and the Capital, and by year
    ## 1022                                                              STUDENTS STUDYING IN RELIGIOUS SCHOOLS AND COLLEGES, by type of religion, aimags and the Capital, and by year
    ## 1023                                                                                                   POVERTY MAIN INDICATORS, by region and location, and by year /1995-2020/
    ## 1024                                                                                                        POVERTY MAIN INDICATORS, by region and location, and by year /2022/
    ## 1025                                                 MONTHLY AVERAGE PER CAPITA CONSUMPTION, by main categories of consumption, poverty status, region, and by year /2003-2020/
    ## 1026                                                                          MINIMUM SUBSISTENCE LEVEL OF POPULATION, per capita per month, by region, and by year /2001-2025/
    ## 1027                                                                           MONTHLY AVERAGE PER CAPITA CONSUMPTION, by main categories of consumption, location, and by year
    ## 1028                                                                            MONTHLY AVERAGE PER CAPITA CONSUMPTION, by household deciles, location, and by year /2003-2020/
    ## 1029                                                                                                          CONSUMPTION SHARES, by household quintiles, location, and by year
    ## 1030                                                                          MINIMUM SUBSISTENCE LEVEL OF POPULATION, per capita per month, by region, and by year /1999-2000/
    ## 1031                                                                                                             POVERTY MAP, by region, soum and dictrict level results /2011/
    ## 1032                                                                                                     POVERTY MAIN INDICATORS, by aimags and region, and by year /2016-2020/
    ## 1033                              INEQUALITY, based on monthly consumption per capita, by region and location, and by year /Gini coefficient and Theil index, by every 2 years/
    ## 1034                                                                                                   REVENUE OF SOCIAL INSURANCE FUND, by aimags and the Capital, and by year
    ## 1035                                                                                                              SOCIAL INSURANCE FUND, by aimags and the Capital, and by year
    ## 1036                                                                              MONTHLY AVERAGE PENSION OF BENEFICIARIES FROM THE SOCIAL INSURANCE FUND, by type and by year.
    ## 1037                                                        NUMBER OF PENSIONARIES, WHO RECEIPT PENSIONS FROM THE SOCIAL INSURANCE FUND, by aimags and the Capital, and by year
    ## 1038                                                                       NUMBER OF OLD-AGE PENSIONERS FROM THE SOCIAL INSURANCE FUND, by aimags and the Capital, and by year.
    ## 1039                                                                         NUMBER OF DISABLED PENSION FROM THE SOCIAL INSURANCE FUND, by aimags and the Capital, and by year.
    ## 1040                                                                     NUMBER OF SURVIVORS PENSIONERS FROM THE SOCIAL INSURANCE FUND, by aimags and the Capital, and by year.
    ## 1041                                                                      NUMBER OF MILITARY PENSIONERS FROM THE SOCIAL INSURANCE FUND, by aimags and the Capital, and by year.
    ## 1042                                                                              EXPENDITURE OF THE SOCIAL INSURANCE FUND ON PENSIONS, by aimags and the Capital, and by year.
    ## 1043                                                                     EXPENDITURE OF THE SOCIAL INSURANCE FUND ON OLD-AGE PENSIONERS, by aimags and the Capital, and by year
    ## 1044                                                                        EXPENDITURE OF THE SOCIAL INSURANCE FUND ON DISABILITY PENSIONS, by aimags the Capital, and by year
    ## 1045                                                                     EXPENDITURE OF THE SOCIAL INSURANCE FUND ON SURVIVORS PENSIONS,by aimags and the Capital, and by year.
    ## 1046                                                                      EXPENDITURE OF THE SOCIAL INSURANCE FUND ON MILITARY PENSIONS, by aimags and the Capital, and by year
    ## 1047                                                                                   NUMBER OF BENEFIT FROM THE SOCIAL INSURANCE FUND, by aimags and the Capital, and by year
    ## 1048                                                        NUMBER OF RECIPIENTS OF DISABILITY BENEFITS FROM THE SOCIAL INSURANCE FUND, by aimags and the Capital, and by year.
    ## 1049                                            NUMBER OF RECIPIENTS OF PREGNANT AND MATERNITY BENEFITS FROM THE SOCIAL INSURANCE FUND, by aimags and the Capital, and by year.
    ## 1050                NUMBER OF RECIPIENTS OF BENEFITS PAID TO FAMILY MEMBERS OF DECEASED INSURED PERSONS FROM THE SOCIAL INSURANCE FUND, by aimags and the Capital, and by year.
    ## 1051                                                      NUMBER OF RECIPIENTS OF UNEMPLOYMENT BENEFITS FROM THE SOCIAL INSURANCE FUND, by aimags and the Capital, and by year.
    ## 1052                                        NUMBER OF RECIPIENTS OF HEALTH REHABILITATION SERVICES FUNDED BY THE SOCIAL INSURANCE FUND, by aimags and the Capital, and by year.
    ## 1053                                                                      TOTAL AMOUNT OF BENEFITS PAID FROM THE SOCIAL INSURANCE FUND, by aimags and the Capital, and by year.
    ## 1054                                                         EXPENDITURE OF THE SOCIAL INSURANCE FUND ON TEMPORARY DISABILITY BENEFITS, by aimags and the Capital, and by year.
    ## 1055                                                     AMOUNT OF PREGNANT AND MATERNITY BENEFITS PAID FROM THE SOCIAL INSURANCE FUND, by aimags and the Capital, and by year.
    ## 1056                                                                    AMOUNT OF FUNERAL BENEFITS PAID FROM THE SOCIAL INSURANCE FUND, by aimags and the Capital, and by year.
    ## 1057                                                               AMOUNT OF UNEMPLOYMENT BENEFITS PAID FROM THE SOCIAL INSURANCE FUND, by aimags and the Capital, and by year.
    ## 1058                                                                                                                                     BENEFIT RECEIVERS, by type of benefits
    ## 1059                                                                                             AMOUNT OF BENEFITS GRANTED FROM THE SOCIAL INSURANCE FUND, by type of benefits
    ## 1060                                                                                Ядуурлын үндэсний түвшнээс доогуур амьжиргаатай хүн амын эзлэх хувь, хүйсээр, насны бүлгээр
    ## 1061                                                                                                                                      TOTAL NUMBER OF CONTRACTS, by quarter
    ## 1062                                                                                                                           INSURANCE CONTRACTS WITH INDIVIDUALS, by quarter
    ## 1063                                                                                                                        INSURANCE CONTRACTS WITH LEGAL ENTITIES, by quarter
    ## 1064                                                                                                                                 INCOME FROM INSURANCE PREMIUMS, by quarter
    ## 1065                                                                                                                                         INSURANCE COMPENSATION, by quarter
    ## 1066                                                                                                                       INDUSTRIAL PRODUCER PRICE INDEX,subdivision by month
    ## 1067                                                                                                    INDUSTRIAL PRODUCER PRICE INDEX, subdivision by month (2016.01-2024.12)
    ## 1068                                                                                                    PRODUCER PRICE INDEX OF ACCOMMODATION SECTOR, aimags, capital, by month
    ## 1069                                                                                   PRODUCER PRICE INDEX OF ACCOMMODATION SECTOR, aimags,capital, by month (2024.04-2024.12)
    ## 1070                                                                                    PRODUCER PRICE INDEX OF ACCOMMODATION SECTOR, aimags,capital by quarter (2016.I-2024.I)
    ## 1071                                                                                         PRODUCER PRICE INDEX OF FOOD AND BEVERAGE SERVICE SECTOR, aimags, capital by month
    ## 1072                                                                        PRODUCER PRICE INDEX OF FOOD AND BEVERAGE SERVICE SECTOR, aimags,capital by month (2024.04-2024.12)
    ## 1073                                                                        PRODUCER PRICE INDEX OF FOOD AND BEVERAGE SERVICE SECTOR, aimags,capital by quarter (2016.I-2024.I)
    ## 1074                                                                                           PRODUCER PRICE INDEX OF INFORMATION & COMMUNICATION SECTOR, subdivision by month
    ## 1075                                                                         PRODUCER PRICE INDEX OF INFORMATION & COMMUNICATION SECTOR, subdivision by month (2024.04-2024.12)
    ## 1076                                                                       PRODUCER PRICE INDEX OF INFORMATION & COMMUNICATION SECTOR, subdivision,by quarter ( 2016.I-2024.I )
    ## 1077                                                                                                        PRODUCER PRICE INDEX OF TRANSPORTATION SECTOR, subdivision by month
    ## 1078                                                                                      PRODUCER PRICE INDEX OF TRANSPORTATION SECTOR, subdivision by month (2024.04-2024.12)
    ## 1079                                                                                     PRODUCER PRICE INDEX OF TRANSPORTATION SECTOR, subdivision by quarter (2016.I-2024.I )
    ## 1080                                                                                                               NUMBER OF MATERNAL DEATHS, by region, aimags and the Capital
    ## 1081                                                                                                                    MATERNAL MOTLALITY, aimags and the Capital and by month
    ## 1082                                                                                                                  NUMBER OF INPATIENTS, aimags and the Capital, and by year
    ## 1083                                                                                                                            INPATIENTS, aimags and the Capital and by month
    ## 1084                                                                         CONSTRUCTION, CAPITAL REPAIRS PERFORMED BY DOMESTIC ENTERPRISES, by soum, district, and by quarter
    ## 1085                                                                            CONSTRUCTION, CAPITAL REPAIRS PERFORMED BY DOMESTIC ENTERPRISES, by soum, district, and by year
    ## 1086                                                                                                                                    CERTIFIED UTILITY MODELS, by, half year
    ## 1087                                                                                                                                          CERTIFIED UTILITY MODELS, by year
    ## 1088                                                                                                                                 COPYRIGHT, by types of work, by half  year
    ## 1089                                                                                                                      PATENT APPLICATIONS FOR INDUSTRIAL DESIGN, for a year
    ## 1090                                                                                                                     PATENT APPLICATIONS FOR INDUSTRIAL DESIGN, half a year
    ## 1091                                                                                                                         PATENT APPLICATIONS FOR INDUSTRIAL DESIGN, by year
    ## 1092                                                                                                                           PATENT APPLICATIONS FOR INVENTION, by, half year
    ## 1093                                                                                                                                 PATENT APPLICATIONS FOR INVENTION, by year
    ## 1094                                                                                                                                             PATENTS IN FORCE, by half year
    ## 1095                                                                                                                                            PATENTS IN FORCE, by, half year
    ## 1096                                                                                                                                               TRADEMARKS IN FORCE, by year
    ## 1097                                                                                                                            THE WORKS PROTECTED BY COPYRIGHT, by, half year
    ## 1098                                                                                                                                  THE WORKS PROTECTED BY COPYRIGHT, by year
    ## 1099                                                                                                                                   APPLICATIONS FOR TRADEMARK, by half year
    ## 1100                                                                                                                                        APPLICATIONS FOR TRADEMARK, by year
    ## 1101                                                                                                                              APPLICATIONS FOR UTILITY MODEL, by, half year
    ## 1102                                                                                                                                    APPLICATIONS FOR UTILITY MODEL, by year
    ## 1103                                                                                                                                         TOTAL PATENT GRANTS, by, half year
    ## 1104                                                                                                                                            TOTAL PATENT GRANTS, for a year
    ## 1105                                                                                                                                         TRADEMARKS IN FORCE, by, half year
    ## 1106                                                                                                                                               TRADEMARKS IN FORCE, by year
    ## 1107                                                                                                                                     TRADEMARK REGISTRATIONS, by, half year
    ## 1108                                                                                                                                           TRADEMARK REGISTRATIONS, by year
    ## 1109                                                                                                                                     UTILITY MODELS IN FORCE, by, half year
    ## 1110                                                                                                                                           UTILITY MODELS IN FORCE, by year
    ## 1111                                                                                KEY INDICATORS OF COMMUNICATION SERVICES, by region, aimags and the Capital, and by quarter
    ## 1112                                                                                   KEY INDICATORS OF COMMUNICATION SERVICES, by region, aimags and the Capital, and by year
    ## 1113                                                                                  NUMBER OF CABLE TELEVISION USERS, by type, region, aimags and the Capital, and by quarter
    ## 1114                                                                                     NUMBER OF CABLE TELEVISION USERS, by type, region, aimags and the Capital, and by year
    ## 1115                                                                                  NUMBER OF INTERNET USERS AND COMPUTERS, by region, aimags and the Capital, and by quarter
    ## 1116                                                                                     NUMBER OF INTERNET USERS AND COMPUTERS, by region, aimags and the Capital, and by year
    ## 1117                                                                                                                        POSTAL SERVICE INDICATORS, by types, and by quarter
    ## 1118                                                                                                                           POSTAL SERVICE INDICATORS, by types, and by year
    ## 1119                                                                      REVENUE OF COMMUNICATION SECTOR, by type of operation, region, aimags and the Capital, and by quarter
    ## 1120                                                                         REVENUE OF COMMUNICATION SECTOR, by type of operation, region, aimags and the Capital, and by year
    ## 1121                                                                                                         INBOUND AND OUTBOUND PASSENGERS, by border crossings, and by month
    ## 1122                                                                                                       INBOUND AND OUTBOUND PASSENGERS, by border crossings, and by quarter
    ## 1123                                                                                                          INBOUND AND OUTBOUND PASSENGERS, by border crossings, and by year
    ## 1124                                                                                                    NUMBER OF INBOUND AND OUTBOUND FOREIGN PASSENGERS, by country, by month
    ## 1125                                                                                                     NUMBER OF INBOUND AND OUTBOUND FOREIGN PASSENGERS, by country, by year
    ## 1126                                                                                                 NUMBER OF INBOUND AND OUTBOUND FOREIGN PASSENGERS, by country, and by year
    ## 1127                                                                                           NUMBER OF INBOUND PASSENGERS, by purpose of vist, border crossings, and by month
    ## 1128                                                                                        NUMBER OF INBOUND PASSENGERS, by purpose of visit, border crossings, and by quarter
    ## 1129                                                                                           NUMBER OF INBOUND PASSENGERS,by purpose of travel, border crossings, and by year
    ## 1130                                                                                                                        NUMBER OF INBOUND TOURISTS, by country, and by year
    ## 1131                                                                                                                     NUMBER OF INBOUND TOURISTS, by country, and by quarter
    ## 1132                                                                                                                        NUMBER OF INBOUND TOURISTS, by country, and by year
    ## 1133                                                                                          NUMBER OF OUTBOUND MONGOLIAN, by purpose of visit, border crossings, and by month
    ## 1134                                                                                          NUMBER OF OUTBOUND MONGOLIAN, by purpose of travel, border crossings, and by year
    ## 1135                                                                                                                                          INCOME OF THE FOOD SERVICE SECTOR
    ## 1136                                                                                                                                          INCOME OF THE FOOD SERVICE SECTOR
    ## 1137                                                                                                                                         INCOME OF THE ACCOMMODATION SECTOR
    ## 1138                                                                                                                                         INCOME OF THE ACCOMMODATION SECTOR
    ## 1139                                                                                                      CARRIED PASSENGERS, by each direction, by national level and by month
    ## 1140                                                                                                    CARRIED PASSENGERS, by each direction, by national level and by quarter
    ## 1141                                                                                                       CARRIED PASSENGERS, by each direction, by national level and by year
    ## 1142                                                                                                           KEY INDICATORS OF AIR TRANSPORT, by national level, and by month
    ## 1143                                                                                                          KEY INDICATORS OF AIR TRANSPORT, by national level and by quarter
    ## 1144                                                                                                             KEY INDICATORS OF AIR TRANSPORT, by national level and by year
    ## 1145                                                                                                            KEY INDICATORS OF AUTO TRANSPORT, by national level and quarter
    ## 1146                                                                                                            KEY INDICATORS OF AUTO TRANSPORT, by national level and by year
    ## 1147                                                                                                        KEY INDICATORS OF RAILWAY TRANSPORT, by national level and by month
    ## 1148                                                                                                      KEY INDICATORS OF RAILWAY TRANSPORT, by national level and by quarter
    ## 1149                                                                                                         KEY INDICATORS OF RAILWAY TRANSPORT, by national level and by year
    ## 1150                                                                                                   EMPLOYEES WORKING ABROAD ON A CONTRACTUAL BASIS, by country, and by year
    ## 1151                                                                                                EMPLOYEES WORKING ABROAD ON A CONTRACTUAL BASIS, by country, and by quarter
    ## 1152                                                                                       EMPLOYMENT INDICATORS OF POPULATION AGED 15 AND OVER, by national level, and by year
    ## 1153                                                                                    EMPLOYMENT INDICATORS OF POPULATION AGED 15 AND OVER, by national level, by and quarter
    ## 1154                                                                                     EMPLOYMENT TO POPULATION RATIO, by sex, age group, aimags and the Capital, and by year
    ## 1155                                                                                  EMPLOYMENT TO POPULATION RATIO, by sex, age group, aimags and the Capital, and by quarter
    ## 1156                                                                                    EMPLOYMENT, by economic activities, sex, age group, aimags and the Capital, and by year
    ## 1157                                                                                  EMPLOYMENT, by economic activities, sex, age group,aimags and the Capital, and by quarter
    ## 1158                                                                                     EMPLOYMENT, by occupation, sex, age group, region, aimags and the Capital, and by year
    ## 1159                                                                                  EMPLOYMENT, by occupation, sex, age group, region, aimags and the Capital, and by quarter
    ## 1160                                                                    EMPLOYMENT, by status in employment, age group, region, aimags and the Capital, and by year /1985-2018/
    ## 1161                                                                 EMPLOYMENT, by status in employment, age group, region, aimags and the Capital, and by quarter /2007-2018/
    ## 1162                                                               EMPLOYMENT, by status in employment, sex, age group, region, aimags and the Capital, and by year, since 2019
    ## 1163                                                            EMPLOYMENT, by status in employment, sex, age group, region, aimags and the Capital, and by quarter, since 2019
    ## 1164                                                                                                                       INJURED PERSONS, by economic activities, and by year
    ## 1165                                                                                                        INJURED PERSONS, by economic activities, and by quarter /2017-2023/
    ## 1166                                                                                                    INJURED PERSONS, by economic activities, type of accidents, and by year
    ## 1167                                                                                     INJURED PERSONS, by economic activities, type of accidents, and by quarter /2017-2023/
    ## 1168                                                                                    LABOUR FORCE PARTICIPATION RATE, by sex, age group, aimags and the Capital, and by year
    ## 1169                                                                                 LABOUR FORCE PARTICIPATION RATE, by sex, age group, aimags and the Capital, and by quarter
    ## 1170                                                                                                       LABOUR FORCE, by sex, age group, aimags and the Capital, and by year
    ## 1171                                                                                                    LABOUR FORCE, by sex, age group, aimags and the Capital, and by quarter
    ## 1172                                                                                       LABOUR UNDERUTILIZATION RATE, by sex, age group, aimags and the Capital, and by year
    ## 1173                                                                             LABOUR UNDERUTILIZATION RATE, by sex, age group, region, aimag and the Capital, and by quarter
    ## 1174                                                                                            LABOUR UNDERUTILIZATION, by sex, age group, aimags and the Capital, and by year
    ## 1175                                                                                         LABOUR UNDERUTILIZATION, by sex, age group, aimags and the Capital, and by quarter
    ## 1176                                                                                    OCCUPATIONAL ACCIDENT, ACUTE POISONINGS, by region, aimags and the Capital, and by year
    ## 1177                                                                     OCCUPATIONAL ACCIDENT, ACUTE POISONINGS, by region, aimags and the Capital, and by quarter /2016-2023/
    ## 1178                                                                PERSONS OUTSIDE THE LABOUR FORCE, by reason, by sex, age group, region, aimags and the Capital, and by year
    ## 1179                                                             PERSONS OUTSIDE THE LABOUR FORCE, by reason, by sex, age group, region, aimags and the Capital, and by quarter
    ## 1180                                                                                                 UNEMPLOYED, by reason, sex, age group, aimags and the Capital, and by year
    ## 1181                                                                                              UNEMPLOYED, by reason, sex, age group, aimags and the Capital, and by quarter
    ## 1182                                                                                                            EMPLOYEES, by group of wages,and share to total, and by quarter
    ## 1183                                                                                                                      EMPLOYEES, by group of wages,and share to total, year
    ## 1184                                                                                                           MONTHLY AVERAGE NOMINAL WAGES , by legal status and gender, year
    ## 1185                                                                                                 MONTHLY AVERAGE NOMINAL WAGES , by legal status and gender, and by quarter
    ## 1186                                                                                                      MONTHLY AVERAGE NOMINAL WAGES , by type of ownership and gender, year
    ## 1187                                                                                                   MONTHLY AVERAGE NOMINAL WAGES , by type of ownership and gender, quarter
    ## 1188                                                                                        MONTHLY AVERAGE NOMINAL WAGES OF EMPLOYEE, by employees size class and gender, year
    ## 1189                                                   MONTHLY AVERAGE NOMINAL WAGES OF EMPLOYEE, by employees size class and gender, by aimags and the Capital, and by quarter
    ## 1190                                                                                                    MONTHLY AVERAGE NOMINAL WAGES, by division of economic activities, year
    ## 1191                                                                                          MONTHLY AVERAGE NOMINAL WAGES, by division of economic activities, and by quarter
    ## 1192                                                                                                              MONTHLY AVERAGE NOMINAL WAGES, by occupation and gender, year
    ## 1193                                                                                                    MONTHLY AVERAGE NOMINAL WAGES, by occupation and gender, and by quarter
    ## 1194                                                                                                                                              MONTHLY AVERAGE NOMINAL WAGES
    ## 1195                                                                                MONTHLY AVERAGE NOMINAL WAGES, by gender, by region, aimags and the Capital, and by quarter
    ## 1196                                                                                                                                    Monthly median wages of employees, year
    ## 1197                                                                            Monthly median wages of employees, by region, aimags and the Capital, by gender, and by quarter
    ## 1198                                                                                            Real wage index (2015=100), by divisions of economic activities, and by quarter
    ## 1199                                                                                                      Real wage index (2015=100), by divisions of economic activities, year
    ## 1200                                                                                                               CRIME CAUSED OF DAMAGES AND DAMAGES WERE RESTITUTED, by year
    ## 1201                                                                                                 CRIME CAUSED OF DAMAGES AND DAMAGES WERE RESTITUTED, by month (cumulative)
    ## 1202                                        Number of Crimes Registered with the Independent Authority Against Corruption, by committed status, aimags and Capital, and by year
    ## 1203                         Number of Crimes Registered with the Independent Authority Against Corruption, by committed status, aimags and Capital, and by Month, (cumulative)
    ## 1204                                                                                     NUMBER OF OFFENDERS, by sex, and by age group , by aimags and the Capital, and by year
    ## 1205                                                                                  NUMBER OF OFFENDERS, by sex, age group, aimags and the Capital, and by month (cumulative)
    ## 1206                                                                                                         NUMBER OF RECORDED CRIMES, by classification of crime, and by year
    ## 1207                                                                                          NUMBER OF RECORDED CRIMES, by classification of crimes, and by month (cumulative)
    ## 1208                                                                                                          NUMBER OF RECORDED CRIMES, by aimags and the Capital, and by year
    ## 1209                                                                                                NUMBER OF RECORDED CRIMES, by aimags and the Capital, by month (cumulative)
    ## 1210                                                                                                                   RECORDED CRIMES, by classification of crime, and by year
    ## 1211                                                                                                                  RECORDED CRIMES, by classification of crime, and by month
    ## 1212                                                                                                                                 SOCIAL INSURANCE FUND, by type and by year
    ## 1213                                                                                                     EXPENDITURE OF SOCIAL INSURANCE FUND, by type and month(by cumulative)
    ## 1214                                                                               NUMBER OF PENSIONARIES, WHO RECEIPT PENSIONS FROM THE SOCIAL INSURANCE FUND, (by cumulative)
    ## 1215                                                                   NUMBER OF PENSIONARIES, WHO RECEIPT PENSIONS FROM THE SOCIAL INSURANCE FUND, by type of pension, annual,
    ## 1216                                                                                                     PERSONS WHO INVOLVED IN THE SOCIAL WELFARE ACTIVITIES, (by cumulative)
    ## 1217                                                                                                                PERSONS INVOLVED SOCIAL WELFARE ACTIVITIES, by type, annual
    ## 1218                                                                                                                                           Revenue of social insurance fund
    ## 1219                                                                                                       REVENUE OF SOCIAL INSURANCE FUND, by type, by month (by cumulative),
    ## 1220                                                                                                                   THE NUMBER OF INSURERS,by type, by month (by cumulative)
    ## 1221                                                                                                                                             The number of insurers, annual
    ## 1222                                                                        TOTAL AMOUNT OF GRANTED PENSIONS AND BENEFITS, SERVICES IN SOCIAL WELFARE ACTIVITES,(by cumulative)
    ## 1223                                                                      TOTAL AMOUNT OF GRANTED PENSIONS AND BENEFITS, SERVICES IN SOCIAL WELFARE ACTIVITES, by type, annual,
    ## 1224                                                                                                       WHO RECEIPT PENSIONS FROM THE SOCIAL INSURANCE FUND, (by cumulative)
    ## 1225                                                                                                   EXPENDITURE OF THE SOCIAL INSURANCE FUND ON PENSIONS,by type and by year
    ##                                                                                                                                                               tbl_nm
    ## 1                                                                                                                                ТӨЛБӨРИЙН ТЭНЦЭЛ, хураангуй, сараар
    ## 2                                                                                               ХҮНСНИЙ ГОЛ НЭР БОЛОН БЕНЗИН ТҮЛШНИЙ 7 ХОНОГИЙН ҮНИЙН МЭДЭЭ, аймгаар
    ## 3                                                                                                     АЙМГИЙН ХЭРЭГЛЭЭНИЙ ҮНИЙН ИНДЕКС, сар бүрийн өөрчлөлт, бүлгээр
    ## 4                                                                                       АЙМГИЙН ХЭРЭГЛЭЭНИЙ ҮНИЙН ИНДЕКС, өмнөх оны мөн үетэй харьцуулснаар, бүлгээр
    ## 5                                                                                  АЙМГИЙН ХЭРЭГЛЭЭНИЙ ҮНИЙН ИНДЕКС, өмнөх оны жилийн эцэстэй харьцуулснаар, бүлгээр
    ## 6                                                                                                              ХЭРЭГЛЭЭНИЙ ҮНИЙН УЛСЫН СУУРЬ ИНДЕКС, бүлгээр, сараар
    ## 7                                                                                                        ХҮНСНИЙ ГОЛ НЭР БОЛОН БЕНЗИН ТҮЛШНИЙ 7 ХОНОГИЙН ҮНИЙН МЭДЭЭ
    ## 8                                                                                                                      ХЭРЭГЛЭЭНИЙ ҮНИЙН УЛСЫН ИНДЕКС, 1991-1-16=100
    ## 9                                                                                     ХЭРЭГЛЭЭНИЙ ҮНИЙН ИНДЕКС, бараа үйлчилгээний бүлэг, өмнөх сартай харьцуулснаар
    ## 10                                                                            ХЭРЭГЛЭЭНИЙ ҮНИЙН ИНДЕКС, бараа үйлчилгээний бүлэг, өмнөх жилийн эцэстэй харьцуулснаар
    ## 11                                                                                       ХЭРЭГЛЭЭНИЙ ҮНИЙН БҮСИЙН ИНДЕКС, бүлгээр, өмнөх оны мөн үетэй харьцуулснаар
    ## 12                                                                                  ХЭРЭГЛЭЭНИЙ ҮНИЙН БҮСИЙН ИНДЕКС, бүлгээр, өмнөх оны жилийн эцэстэй харьцуулснаар
    ## 13                                                                                              ХЭРЭГЛЭЭНИЙ ҮНИЙН БҮСИЙН ИНДЕКС, бүлгээр, өмнөх сартай харьцуулснаар
    ## 14                                                                             ХЭРЭГЛЭЭНИЙ ҮНИЙН ИНДЕКС, бараа үйлчилгээний бүлэг, өмнөх оны мөн үетэй харьцуулснаар
    ## 15                                                                                          УЛААНБААТАР ХОТЫН ХЭРЭГЛЭЭНИЙ ҮНИЙН ИНДЕКС, бүлгээр, сар бүрийн өөрчлөлт
    ## 16                                                                       ХЭРЭГЛЭЭНИЙ ҮНИЙН УЛСЫН ИНДЕКСИЙН ӨӨРЧЛӨЛТ, бүлгээр, өмнөх оны жилийн эцэстэй харьцуулснаар
    ## 17                                                                                          ХЭРЭГЛЭЭНИЙ ҮНИЙН УЛСЫН ИНДЕКСИЙН ӨӨРЧЛӨЛТ, бүлгээр, сар бүрийн өөрчлөлт
    ## 18                                                                            ХЭРЭГЛЭЭНИЙ ҮНИЙН УЛСЫН ИНДЕКСИЙН ӨӨРЧЛӨЛТ, бүлгээр, өмнөх оны мөн үетэй харьцуулснаар
    ## 19                                                                       УЛААНБААТАР ХОТЫН ХЭРЭГЛЭЭНИЙ ҮНИЙН ИНДЕКС, бүлгээр, өмнөх оны жилийн эцэстэй харьцуулснаар
    ## 20                                                                            УЛААНБААТАР ХОТЫН ХЭРЭГЛЭЭНИЙ ҮНИЙН ИНДЕКС, бүлгээр, өмнөх оны мөн үетэй харьцуулснаар
    ## 21                                                                                                                                    ИНФЛЯЦЫН ЖИЛИЙН ТҮВШИН, хувиар
    ## 22                                                                            ГОЛ НЭРИЙН ЗАРИМ БАРААНЫ ДУНДАЖ ҮНЭ, бараа, үйлчилгээний төрөл, аймаг, нийслэл, сараар
    ## 23                                                                                         АГААР БОХИРДУУЛАХ БОДИСЫН ЖИЛИЙН ДУНДАЖ АГУУЛАМЖ, станцын байршил, жилээр
    ## 24                                                                                                                УСНЫ ЧАНАРЫН ТӨЛӨВ БАЙДАЛ, станцын байршил, жилээр
    ## 25                                                                                                           МОНГОЛ УЛСЫН ГАЗРЫН НЭГДМЭЛ САН, үндсэн ангилал, жилээр
    ## 26                                                                                              МОНГОЛ УЛСЫН ИРГЭНД ӨМЧЛYYЛСЭН ГАЗРЫН ТАЙЛАН, аймаг, нийслэл, жилээр
    ## 27                                                                                                  ОЙ, ХЭЭРИЙН ТҮЙМРИЙН ТОО, давхардсан тоо, аймаг, нийслэл, жилээр
    ## 28                                                                                                             ОЙГООС БЭЛТГЭСЭН МОДНЫ ХЭМЖЭЭ, аймаг, нийслэл, жилээр
    ## 29                                                                                                         ХОХИРОЛ УЧИРСАН ТАЛБАЙ, үндсэн ангилал, улсын дүн, жилээр
    ## 30                                                                       ТОХИОЛДСОН ГАМШИГТ ҮЗЭГДЭЛ, УЧИРСАН ХОХИРОЛ, үндсэн үзүүлэлт, улсын дүн, сараар (өссөн дүн)
    ## 31                                                                              АГААРЫН ЧАНАРЫН СТАНДАРТ ДАХЬ ХҮЛЦЭХ ХЭМ ХЭМЖЭЭ, үндсэн үзүүлэлт, шинэчлэгдсэн оноор
    ## 32                                                                                                 АГААР ДАХЬ БОХИРДУУЛАГЧ БОДИСЫН АГУУЛАМЖ, станцын байршил, сараар
    ## 33                                                                                                         ХҮЛЭМЖИЙН ХИЙН ШИНГЭЭЛТ, ЯЛГАРАЛ, үндсэн үзүүлэлт, жилээр
    ## 34                                                                                           МОНГОЛ УЛСЫН ГАЗРЫН НЭГДМЭЛ САН, үндсэн ангилал, аймаг, нийслэл, жилээр
    ## 35                                                                                                                АГААРЫН ДУНДАЖ ТЕМПЕРАТУР, станцын байршил, сараар
    ## 36                                                                                                                АГААРЫН ДУНДАЖ ТЕМПЕРАТУР, станцын байршил, жилээр
    ## 37                                                                                                                    ХУР ТУНАДАСНЫ НИЙЛБЭР, станцын байршил, сараар
    ## 38                                                                                                                САЛХИНЫ ҮНЭМЛЭХҮЙ ИХ ХУРД, станцын байршил, сараар
    ## 39                                                                                                              ШОРООН ШУУРГАТАЙ ӨДРИЙН ТОО, станцын байршил, сараар
    ## 40                                                                                                               ЦАСАН ШУУРГАТАЙ ӨДРИЙН ТОО, станцын байршил, сараар
    ## 41                                                                                                                             ГАЗАР ТАРИАЛАНГИЙН БИЕТ УРСГАЛЫН ДАНС
    ## 42                                                                                                                    МАЛ АЖ АХУЙН БҮТЭЭГДЭХҮҮНИЙ БИЕТ УРСГАЛЫН ДАНС
    ## 43                                                                                                                                   ТАРИАЛАЛТЫН БИЕТ ХӨРӨНГИЙН ДАНС
    ## 44                                                                                                                                         МАЛЫН БИЕТ ХӨРӨНГИЙН ДАНС
    ## 45                                                                                                                                       БОРДООНЫ БИЕТ УРСГАЛЫН ДАНС
    ## 46                                                                                                                     УРГАМАЛ ХАМГААЛЛЫН БОДИСЫН БИЕТ УРСГАЛЫН ДАНС
    ## 47                                                                                                                                      УСНЫ БИЕТ АШИГЛАЛТЫН ХҮСНЭГТ
    ## 48                                                                                                                                         УСНЫ БИЕТ НӨӨЦИЙН ХҮСНЭГТ
    ## 49                                                                                                    БАЙГАЛЬ ОРЧНЫГ ХАМГААЛАХ ҮНДЭСНИЙ НИЙТ ЗАРДАЛ, зардлын төрлөөр
    ## 50                                                                                            БАЙГАЛЬ ОРЧНЫГ ХАМГААЛАХ ҮНДЭСНИЙ НИЙТ ЗАРДАЛ, эдийн засгийн сектороор
    ## 51                                                                                БАЙГАЛЬ ОРЧНЫГ ХАМГААЛАХ ҮНДЭСНИЙ НИЙТ ЗАРДАЛ, байгаль хамгаалах үйл ажиллагаагаар
    ## 52                                                                                                                                          МАТЕРИАЛЫН УРСГАЛЫН ДАНС
    ## 53                                                                                                                                       БАЙГАЛЬ ОРЧНЫ ТАТВАРЫН ДАНС
    ## 54                                                                                                         АНХДАГЧ БОЛОН ХОЁРДОГЧ ЭРЧИМ ХҮЧНИЙ НИЙЛҮҮЛЭЛТ, салбараар
    ## 55                                                                                                                     ЭРЧИМ ХҮЧНИЙ НИЙТ НИЙЛҮҮЛЭЛТ, бүтээгдэхүүнээр
    ## 56                                                                                                                        ЭРЧИМ ХҮЧНИЙ НИЙТ АШИГЛАЛТ, бүрэлдэхүүнээр
    ## 57                                                                                                                       ЭРЧИМ ХҮЧНИЙ НИЙТ АШИГЛАЛТ, бүтээгдэхүүнээр
    ## 58                                                                                                                   ЭРЧИМ ХҮЧНИЙ ДОТООДЫН ХЭРЭГЛЭЭ, бүтээгдэхүүнээр
    ## 59                                                                                                              ГАДААД ХУДАЛДААНЫ НӨХЦӨЛИЙН ИНДЕКС, сараар, 2015=100
    ## 60                                                                                                            ГАДААД ХУДАЛДААНЫ НӨХЦӨЛИЙН ИНДЕКС, улирлаар, 2015=100
    ## 61                                                                                        ГАДААД ХУДАЛДААНЫ НИЙТ ЭРГЭЛТ, ЭКСПОРТ, ИМПОРТ, ТЭНЦЭЛ, сараар (өссөн дүн)
    ## 62                                                                                                    ГАДААД ХУДАЛДААНЫ НИЙТ ЭРГЭЛТ, ЭКСПОРТ, ИМПОРТ, ТЭНЦЭЛ, жилээр
    ## 63                                                                                                              ГАДААД ХУДАЛДААНЫ САРЫН НИЙТ ЭРГЭЛТ, ЭКСПОРТ, ИМПОРТ
    ## 64                                                                                                                      ЭКСПОРТ, барааны бүлгээр, сараар (өссөн дүн)
    ## 65                                                                                                                                  ЭКСПОРТ, барааны бүлгээр, жилээр
    ## 66                                                                                 ЭКСПОРТЫН ЗАРИМ ГОЛ НЭРИЙН БАРААНЫ ТОО ХЭМЖЭЭ БОЛОН ҮНИЙН ДҮН, сараар (өссөн дүн)
    ## 67                                                                                             ЭКСПОРТЫН ЗАРИМ ГОЛ НЭРИЙН БАРААНЫ ТОО ХЭМЖЭЭ БОЛОН ҮНИЙН ДҮН, жилээр
    ## 68                                                                                                                                           ЭКСПОРТ, улсаар, жилээр
    ## 69                                                                                                                          ИМПОРТ, барааны бүлгээр, сар (өссөн дүн)
    ## 70                                                                                                                                   ИМПОРТ, барааны бүлгээр, жилээр
    ## 71                                                                                  ИМПОРТЫН ЗАРИМ ГОЛ НЭРИЙН БАРААНЫ ТОО ХЭМЖЭЭ БОЛОН ҮНИЙН ДҮН, сараар (өссөн дүн)
    ## 72                                                                                              ИМПОРТЫН ЗАРИМ ГОЛ НЭРИЙН БАРААНЫ ТОО ХЭМЖЭЭ БОЛОН ҮНИЙН ДҮН, жилээр
    ## 73                                                                                                                                            ИМПОРТ, улсаар, жилээр
    ## 74                                                                                                           ЭКСПОРТЫН ҮНИЙН ИНДЕКС, барааны бүлгээр, сараар, хувиар
    ## 75                                                                                                            ИМПОРТЫН ҮНИЙН ИНДЕКС, барааны бүлгээр, сараар, хувиар
    ## 76                                                                                                                                  ЗАСГИЙН ГАЗРЫН НИЙТ ӨР, улирлаар
    ## 77                                                                                                                  ЗАСГИЙН ГАЗРЫН НИЙТ ӨРИЙН ЭРГЭН ТӨЛӨЛТ, улирлаар
    ## 78                                                                                                                             МОНГОЛ УЛСЫН НИЙТ ГАДААД ӨР, улирлаар
    ## 79                                                                                             УЛСЫН НЭГДСЭН ТӨСВИЙН ТЭНЦВЭРЖҮҮЛСЭН ОРЛОГО , ЗАРЛАГА, ТЭНЦЭЛ, жилээр
    ## 80                                                                                                     УЛСЫН ТӨСВИЙН ЗАРЛАГА, төсвийн ерөнхийлөн захирагчаар, жилээр
    ## 81                                                                                 МОНГОЛ УЛСЫН НЭГДСЭН ТӨСВИЙН ОРЛОГО, нэр төрлийн ангиллаар, сараар, өссөн дүнгээр
    ## 82                                                                                                МОНГОЛ УЛСЫН НЭГДСЭН ТӨСВИЙН ОРЛОГО, нэр төрлийн ангиллаар, жилээр
    ## 83                                                                                                        ОРОН НУТГИЙН ТӨСВИЙН ОРЛОГО, нэр төрлийн ангиллаар, жилээр
    ## 84                                                                                МОНГОЛ УЛСЫН НЭГДСЭН ТӨСВИЙН ЗАРЛАГА, нэр төрлийн ангиллаар, сараар, өссөн дүнгээр
    ## 85                                                                                               МОНГОЛ УЛСЫН НЭГДСЭН ТӨСВИЙН ЗАРЛАГА, нэр төрлийн ангиллаар, жилээр
    ## 86                                                                                                       ОРОН НУТГИЙН ТӨСВИЙН ЗАРЛАГА, нэр төрлийн ангиллаар, жилээр
    ## 87                                                                                    МОНГОЛ УЛСЫН НЭГДСЭН ТӨСВИЙН ТЭНЦВЭРЖҮҮЛСЭН НИЙТ ТЭНЦЭЛ, сараар, өссөн дүнгээр
    ## 88                                                                      УЛСЫН ТӨСВӨӨС ОРОН НУТГИЙН ТӨСӨВТ ОЛГОСОН САНХYYГИЙН ДЭМЖЛЭГ, бүс, аймаг, нийслэлээр, жилээр
    ## 89                                                                                                           ОРОН НУТГИЙН ТӨСВИЙН ЗАРЛАГА, аймаг, нийслэлээр, жилээр
    ## 90                                                                                                            ОРОН НУТГИЙН ТӨСВИЙН ОРЛОГО, аймаг, нийслэлээр, жилээр
    ## 91                                                                                                                         ОРОН СУУЦНЫ ҮНИЙН ЖИЛИЙН ӨӨРЧЛӨЛТ, хувиар
    ## 92                                                               ОРОН СУУЦНЫ 1 М.КВ ТАЛБАЙН ДУНДАЖ ҮНЭ, Улаанбаатар хотын төвийн 6 дүүргээр, улирлаар, 2007-2021 онд
    ## 93                                                                                ОРОН СУУЦНЫ 1 М.КВ ТАЛБАЙН ДУНДАЖ ҮНЭ, Улаанбаатар хотын төвийн 6 дүүргээр, сараар
    ## 94                                                                                                                                  ОРОН СУУЦНЫ ҮНИЙН ИНДЕКС, сараар
    ## 95                                                                                                                           ОРОН СУУЦНЫ ФОНД, сууцны талбай, жилээр
    ## 96                                                                                                              АШИГЛАЛТАД ОРУУЛСАН ОРОН СУУЦ, өмчийн хэлбэр, жилээр
    ## 97                                                                                              ХӨРӨНГӨ ОРУУЛАЛТ, санхүүжилтийн эх үүсвэр, технологийн бүтэц, жилээр
    ## 98                                                                                                                    ХӨРӨНГӨ ОРУУЛАЛТ, эдийн засгийн салбар, жилээр
    ## 99                                                                                                            УЛСЫН ТӨСВИЙН ХӨРӨНГӨ ОРУУЛАЛТ, аймаг, нийслэл, жилээр
    ## 100                                                                                                    ОРОН НУТГИЙН ТӨСВИЙН ХӨРӨНГӨ ОРУУЛАЛТ, аймаг, нийслэл, жилээр
    ## 101                                                                    МОНГОЛ УЛСАД ОРСОН ГАДААДЫН ШУУД ХӨРӨНГӨ ОРУУЛАЛТЫН ҮЛДЭГДЭЛ, хөрөнгө оруулагч улсаар, жилээр
    ## 102                                                                  МОНГОЛ УЛСАД ОРСОН ГАДААДЫН ШУУД ХӨРӨНГӨ ОРУУЛАЛТЫН ҮЛДЭГДЭЛ, хөрөнгө оруулагч улсаар, улирлаар
    ## 103                                                                 МОНГОЛ УЛСАД ОРСОН ГАДААДЫН ШУУД ХӨРӨНГӨ ОРУУЛАЛТЫН ОРОХ УРСГАЛ, хөрөнгө оруулагч улсаар, жилээр
    ## 104                                                               МОНГОЛ УЛСАД ОРСОН ГАДААДЫН ШУУД ХӨРӨНГӨ ОРУУЛАЛТЫН ОРОХ УРСГАЛ, хөрөнгө оруулагч улсаар, улирлаар
    ## 105                                                             МОНГОЛ УЛСАД ОРСОН ГАДААДЫН ШУУД ХӨРӨНГӨ ОРУУЛАЛТЫН ҮЛДЭГДЭЛ, эдийн засгийн ү/а-ны салбараар, жилээр
    ## 106                                                           МОНГОЛ УЛСАД ОРСОН ГАДААДЫН ШУУД ХӨРӨНГӨ ОРУУЛАЛТЫН ҮЛДЭГДЭЛ, эдийн засгийн ү/а-ны салбараар, улирлаар
    ## 107                                                          МОНГОЛ УЛСАД ОРСОН ГАДААДЫН ШУУД ХӨРӨНГӨ ОРУУЛАЛТЫН ОРОХ УРСГАЛ, эдийн засгийн ү/а-ны салбараар, жилээр
    ## 108                                                        МОНГОЛ УЛСАД ОРСОН ГАДААДЫН ШУУД ХӨРӨНГӨ ОРУУЛАЛТЫН ОРОХ УРСГАЛ, эдийн засгийн ү/а-ны салбараар, улирлаар
    ## 109                                                                                                                          ҮНЭТ ЦААСНЫ ЗАХ ЗЭЭЛИЙН АРИЛЖАА, сараар
    ## 110                                                                                                                  ҮНЭТ ЦААСНЫ ЗАХ ЗЭЭЛИЙН ҮНДСЭН ҮЗҮҮЛЭЛТ, сараар
    ## 111                                                                                                                                      МӨНГӨНИЙ НИЙЛҮҮЛЭЛТ, сараар
    ## 112                                                                                                                 ХӨДӨӨ АЖ АХУЙН БИРЖИЙН ҮНДСЭН ҮЗҮҮЛЭЛТ, улирлаар
    ## 113                                                                                 АЖ АХУЙН НЭГЖ, ИРГЭДЭД ОЛГОСОН ЗЭЭЛИЙН ӨРИЙН ҮЛДЭГДЭЛ, зээлийн ангиллаар, сараар
    ## 114                                                                                                           ЗЭЭЛИЙН ӨРИЙН ҮЛДЭГДЭЛ, бүс, аймаг, нийслэлээр, жилээр
    ## 115                                                                                                   ИРГЭДИЙН ХАДГАЛАМЖИЙН ҮЛДЭГДЭЛ, бүс, аймаг, нийслэлээр, жилээр
    ## 116                                                                                                  ЧАНАРГҮЙ ЗЭЭЛИЙН ӨРИЙН ҮЛДЭГДЭЛ, бүс, аймаг, нийслэлээр, жилээр
    ## 117                                            МАЛЫН ИНДЕКСЖҮҮЛСЭН ДААТГАЛД ХАМРАГДСАН МАЛЧИН ӨРХ, ДААТГУУЛСАН МАЛЫН ТОО, бүс, аймаг, нийслэл, сум, дүүргээр, жилээр
    ## 118                                                                                                                                      ГАДААД ВАЛЮТЫН ХАНШ, сараар
    ## 119                                                                                                                  ҮНЭТ ЦААСНЫ ЗАХ ЗЭЭЛИЙН ҮНДСЭН ҮЗҮҮЛЭЛТ, жилээр
    ## 120                                                                                                                          БАНКУУДЫН НЭГДСЭН ТАЙЛАН ТЭНЦЭЛ, сараар
    ## 121                                                                                                                                      ЗЭЭЛИЙН ХҮҮ, хувиар, сараар
    ## 122                                                                                                       НИЙТ ХАДГАЛАМЖ, бүс, аймаг, нийслэл, сум, дүүргээр, жилээр
    ## 123                                                                                          НИЙТ ЗЭЭЛИЙН ӨРИЙН ҮЛДЭГДЭЛ, бүс, аймаг, нийслэл, сум, дүүргээр, жилээр
    ## 124                                                                                                           ХАДГАЛАМЖ, ЗЭЭЛИЙН ХОРШООДЫН ҮНДСЭН ҮЗҮҮЛЭЛТ, улирлаар
    ## 125                                                                                                       БАНК БУС САНХҮҮГИЙН БАЙГУУЛЛАГЫН ҮНДСЭН ҮЗҮҮЛЭЛТ, улирлаар
    ## 126                                                                                                         ИРГЭДЭД ОЛГОСОН ИПОТЕКИЙН ЗЭЭЛИЙН ӨРИЙН ҮЛДЭГДЭЛ, сараар
    ## 127                                                                                  ТӨГРӨГИЙН НЭРЛЭСЭН БОЛОН БОДИТ ҮЙЛЧИЛЖ БУЙ ХАНШИЙН ИНДЕКС, (NEER, REER), сараар
    ## 128                                                                                                  ИРГЭДЭД ОЛГОСОН ЗЭЭЛИЙН ӨРИЙН ҮЛДЭГДЭЛ, зээлийн төрлөөр, сараар
    ## 129                                                ЖИЖИГ, ДУНД ҮЙЛДВЭР ЭРХЛЭГЧ ИРГЭД, ААН-Д ОЛГОСОН ЗЭЭЛИЙН ӨРИЙН ҮЛДЭГДЭЛ, эдийн засгийн салбарын ангиллаар, сараар
    ## 130                                                                                     ДОТООДЫН НИЙТ БҮТЭЭГДЭХҮҮН, үйлдвэрлэлийн арга, эдийн засгийн салбар, жилээр
    ## 131                                                                                                   ҮНДЭСНИЙ НИЙТ ОРЛОГО, ҮНДЭСНИЙ НИЙТ ЭЗЭМШЛИЙН ОРЛОГО, улирлаар
    ## 132                                                       ДНБ-Д ЖИЖИГ, ДУНД ҮЙЛДВЭР, ҮЙЛЧИЛГЭЭ ЭРХЛЭГЧДИЙН НЭМЭГДЭЛ ӨРТГИЙН ЭЗЛЭХ ХУВЬ, эдийн засгийн салбар, жилээр
    ## 133                                                                                                              ДОТООДЫН НИЙТ БҮТЭЭГДЭХҮҮНИЙ САЛБАРЫН БҮТЭЦ, жилээр
    ## 134                                                                                                       ДОТООДЫН НИЙТ БҮТЭЭГДЭХҮҮН, эцсийн ашиглалтын арга, жилээр
    ## 135                                                                                                   ДОТООДЫН НИЙТ БҮТЭЭГДЭХҮҮН, эцсийн ашиглалтын аргаар, улирлаар
    ## 136                                                                                            ДОТООДЫН НИЙТ БҮТЭЭГДЭХҮҮН, үйлдвэрлэлийн аргаар, улирлаар, салбараар
    ## 137                                                                                  ДНБ-Д ХУВИЙН ХЭВШЛИЙН НЭМЭГДЭЛ ӨРТГИЙН ЭЗЛЭХ ХУВЬ, эдийн засгийн салбар, жилээр
    ## 138                                                                                        ДНБ-Д ХУВИЙН ХЭВШЛИЙН НЭМЭГДЭЛ ӨРТГИЙН ЭЗЛЭХ ХУВЬ, аймаг, нийслэл, жилээр
    ## 139                                                                                                                 ДОТООДЫН НИЙТ БҮТЭЭГДЭХҮҮН, орлогын арга, жилээр
    ## 140                                                                                                               ДОТООДЫН НИЙТ БҮТЭЭГДЭХҮҮН, аймаг, нийслэл, жилээр
    ## 141                                                                                                                                     ҮНДЭСНИЙ НИЙТ ОРЛОГО, жилээр
    ## 142                                                                                                               НЭГ ХҮНД НОГДОХ ДОТООДЫН НИЙТ БҮТЭЭГДЭХҮҮН, жилээр
    ## 143                                                                                               НЭГ ХҮНД НОГДОХ ДОТООДЫН НИЙТ БҮТЭЭГДЭХҮҮН, аймаг, нийслэл, жилээр
    ## 144                                                                                                                     НЭГ ХҮНД НОГДОХ ҮНДЭСНИЙ НИЙТ ОРЛОГО, жилээр
    ## 145                                                                                                    ҮНДСЭН ХӨРӨНГИЙН НИЙТ ХУРИМТЛАЛ, эдийн засгийн салбар, жилээр
    ## 146                                                                                              ДОТООДЫН НИЙТ БҮТЭЭГДЭХҮҮНИЙ САЛБАРЫН БҮТЭЦ, аймаг, нийслэл, жилээр
    ## 147                                                                                         ДОТООДЫН НИЙТ БҮТЭЭГДЭХҮҮН, эдийн засгийн салбар, аймаг, нийслэл, жилээр
    ## 148                                                                ДОТООДЫН НИЙТ БҮТЭЭГДЭХҮҮН, үйлдвэрлэлийн аргаар, улирлаар, нэгтгэсэн 10 салбараар, өссөн дүнгээр
    ## 149                                                                          ДОТООДЫН НИЙТ БҮТЭЭГДЭХҮҮН, үйлдвэрлэлийн аргаар, улирлаар, 19 салбараар, өссөн дүнгээр
    ## 150                                                                                    ДОТООДЫН НИЙТ БҮТЭЭГДЭХҮҮН, эцсийн ашиглалтын аргаар, улирлаар, өссөн дүнгээр
    ## 151                                                                                         САЛБАР ХООРОНДЫН ТЭНЦЭЛ, импортын өрсөлдөөнт бус төрөл, 20x20 хэмжээсээр
    ## 152                                                                                             САЛБАР ХООРОНДЫН ТЭНЦЭЛ, импортын өрсөлдөөнт төрөл, 20x20 хэмжээсээр
    ## 153                                                                                                                                НӨӨЦИЙН ХҮСНЭГТ, 48х32 хэмжээсээр
    ## 154                                                                                                                             АШИГЛАЛТЫН ХҮСНЭГТ, 48x32 хэмжээсээр
    ## 155                                                                                   НЭГ АЖИЛЛАГЧИД НОГДОХ ДОТООДЫН НИЙТ БҮТЭЭГДЭХҮҮН, эдийн засгийн салбар, жилээр
    ## 156                                                                                 НЭГ АЖИЛЛАГЧИД НОГДОХ ДОТООДЫН НИЙТ БҮТЭЭГДЭХҮҮН, эдийн засгийн салбар, улирлаар
    ## 157                                                                          БИЗНЕСИЙН СЕКТОРЫН ХӨДӨЛМӨРИЙН БҮТЭЭМЖИЙН ЖИЛИЙН ӨӨРЧЛӨЛТ, эдийн засгийн салбар, жилээр
    ## 158                                                                                                                   ТӨРСӨН ХҮҮХДИЙН ТОО, эхийн насны бүлэг, жилээр
    ## 159                                                                                                                                    ТӨРӨЛТИЙН КОЭФФИЦИЕНТ, жилээр
    ## 160                                                                                                              ТӨРӨХ ҮЕИЙН ХҮЙСИЙН ХАРЬЦАА, аймаг, нийслэл, жилээр
    ## 161                                                                                                                        ҮР ХӨНДӨЛТИЙН ТОО, аймаг, нийслэл, жилээр
    ## 162                                                                                                                              ЭХИЙН ЭНДЭГДЭЛ, сум, дүүрэг, жилээр
    ## 163                                                                                                                                ЭМНЭЛГИЙН ОРНЫ ТОО, төрөл, жилээр
    ## 164                                                                                                    ЭРҮҮЛ МЭНДИЙН БАЙГУУЛЛАГЫН ТОО, төрөл, аймаг, нийслэл, жилээр
    ## 165                                                                                              ХҮН АМЫН НАС БАРАЛТЫН ЗОНХИЛОХ ШАЛТГААН, хүйс, өвчний бүлэг, жилээр
    ## 166                                                                                    ХОРТ ХАВДРААР ШИНЭЭР ӨВЧЛӨГЧДИЙН ТОО, 10000 хүнд ногдох, хорт хавдрын төрлөөр
    ## 167                                                                                                                         НЯЛХСЫН ЭНДЭГДЭЛ, аймаг, нийслэл, сараар
    ## 168                                                                      НЯЛХСЫН ЭНДЭГДЛИЙН ТҮВШИН, амьд төрсөн 1000 хүүхэд тутамд ногдохоор, аймаг, нийслэл, сараар
    ## 169                                                                                                                              НЯЛХСЫН ЭНДЭГДЭЛ, хүйс, сум, жилээр
    ## 170                                                                              НЯЛХСЫН ЭНДЭГДЛИЙН ТҮВШИН, амьд төрсөн 1000 хүүхэд тутамд ногдох, хүйс, сум, жилээр
    ## 171                                                                      НЯЛХСЫН ЭНДЭГДЛИЙН ТҮВШИН, амьд төрсөн 1000 хүүхэд тутамд ногдохоор, аймаг, нийслэл, сараар
    ## 172                                                                                    НЯЛХСЫН ЭНДЭГДЛИЙН ТҮВШИН, амьд төрсөн 1000 хүүхэд тутамд ногдох, сум, жилээр
    ## 173                                                                                                                                         АМАРЖСАН ЭХ, сум, жилээр
    ## 174                                                                                                                              АМАРЖСАН ЭХ, аймаг, нийслэл, сараар
    ## 175                                                        АМАРЖСАН ЭХЧҮҮДЭЭС 6, ТҮҮНЭЭС ДЭЭШ УДАА ЖИРЭМСНИЙ ХЯНАЛТАД ХАМРАГДСАН ЭМЭГТЭЙЧҮҮД, аймаг, нийслэл, сараар
    ## 176                                                                                                                       АМЬД ТӨРСӨН ХҮҮХЭД, аймаг, нийслэл, сараар
    ## 177                                                                                                                      АМЬД ТӨРСӨН ХҮҮХДИЙН ТОО, хүйс, сум, жилээр
    ## 178                                                                                              ЭХИЙН ЭНДЭГДЛИЙН ХАРЬЦАА (100000 амьд төрөлтөд ногдох), сум, жилээр
    ## 179                                                                                                                 НАС БАРАЛТ, зонхилох өвчний ангилал, сум, жилээр
    ## 180                                                                                                                               НАС БАРАЛТ, аймаг, нийслэл, сараар
    ## 181                                                                                                                      ЭМНЭЛЭГТ НАС БАРАЛТ, аймаг, нийслэл, сараар
    ## 182                                                               ЖИРЭМСЭН ЭМЭГТЭЙЧҮҮДИЙН ЭХНИЙ 3 САРТАЙД ЭМНЭЛГИЙН ХЯНАЛТАД ХАМРАГДСАН ХУВЬ, аймаг, нийслэл, жилээр
    ## 183                                                      ТАВ ХҮРТЭЛХ НАСНЫ ХҮҮХДИЙН ЭНДЭГДЛИЙН ТҮВШИН, амьд төрсөн 1000 хүүхэд тутамд ногдох, aймаг, нийслэл, сараар
    ## 184                                                                                                    НЭГ ЦАГИЙН ДОТОР ХӨХӨӨ АМЛАСАН ХҮҮХЭД, аймаг, нийслэл, сараар
    ## 185                                                                                                         ТӨРӨЛХИЙН ГАЖИГТАЙ ТӨРСӨН ХҮҮХЭД, аймаг, нийслэл, сараар
    ## 186                                                                                                  2500 ГРАММААС БАГА ЖИНТЭЙ ТӨРСӨН ХҮҮХЭД, аймаг, нийслэл, сараар
    ## 187                                                                                                                            АМЬГҮЙ ТӨРӨЛТ, аймаг, нийслэл, сараар
    ## 188                                                                                                                          НЯРАЙН ЭНДЭГДЭЛ, аймаг, нийслэл, сараар
    ## 189                                                                          НЯРАЙН ЭНДЭГДЛИЙН ТҮВШИН, амьд төрсөн 1000 хүүхэд тутамд ногдох, аймаг, нийслэл, сараар
    ## 190                                                                                                           ТАВ ХҮРТЭЛХ НАСНЫ ХҮҮХДИЙН ЭНДЭГДЭЛ, хүйс, сум, жилээр
    ## 191                                                                       ТАВ ХҮРТЭЛХ НАСНЫ ХҮҮХДИЙН ЭНДЭГДЛИЙН ТҮВШИН, 1000 АМЬД ТӨРӨЛТӨД НОГДОХ, хүйс, сум, жилээр
    ## 192                                                            ЖИРЭМСНИЙ ХЯНАЛТАД 6, ТҮҮНЭЭС ДЭЭШ УДАА ХАМРАГДСАН ТӨРСӨН ЭМЭГТЭЙЧҮҮДИЙН ХУВЬ, аймаг, нийслэл, жилээр
    ## 193                                               ӨСВӨР НАСНЫ 1000 ЭМЭГТЭЙД НОГДОХ ТӨРӨЛТИЙН ТҮВШИН (10-14, 15-19 насны 1000 эмэгтэйд ногдох) аймаг, нийслэл, жилээр
    ## 194                                                                             ЖИРЭМСЛЭХЭЭС СЭРГИЙЛЭХ АРГА, ХЭРЭГСЭЛ ХЭРЭГЛЭДЭГ ЭМЭГТЭЙЧҮҮД, аймаг, нийслэл, жилээр
    ## 195                                                                                                      ТАВ ХҮРТЭЛХ НАСНЫ ХҮҮХДИЙН ЭНДЭГДЭЛ, аймаг, нийслэл, сараар
    ## 196                                                                         ЭХИЙН ЭНДЭГДЛИЙН ХАРЬЦАА амьд төрсөн 100000 хүүхэд тутамд ногдох, аймаг, нийслэл, сараар
    ## 197                                                                                  ГЭРЛЭСЭН/ ХАМТРАН АМЬДРАГЧТАЙ, ЖСАХ-ИЙН ХЭРЭГЦЭЭ ХАНГАГДСАН ЭМЭГТЭЙЧҮҮДИЙН ХУВЬ
    ## 198                                                                                                    ХОРТ ХАВДРААР НАС БАРАГЧДЫН ТОО, 10000 хүнд ногдохоор, жилээр
    ## 199                                                                                                            ХАЛДВАРТ ӨВЧНӨӨР ӨВЧЛӨГЧИД, өвчний төрөл, сум, жилээр
    ## 200                                                                                                               ХАЛДВАРТ ӨВЧНӨӨР ӨВЧЛӨГЧИД, аймаг, нийслэл, жилээр
    ## 201                                                                                                           ХАЛДВАРТ ӨВЧНӨӨР ӨВЧЛӨГЧИД, зарим өвчний төрөл, сараар
    ## 202                                                                                                              ХОРТ ХАВДРААР ШИНЭЭР ӨВЧЛӨГЧИД, насны бүлэг, жилээр
    ## 203                                                                   ХОРТ ХАВДРААР ШИНЭЭР ӨВЧЛӨГЧИД, НАС БАРАГЧИД, 10 000 хүн амд ногдохоор, аймаг, нийслэл, жилээр
    ## 204                                                                                               ЕРӨНХИЙ БОЛОВСРОЛЫН СУРГУУЛИЙН ҮНДСЭН БАГШ, аймаг, нийслэл, жилээр
    ## 205                                                                                                  ЕРӨНХИЙ БОЛОВСРОЛЫН СУРГУУЛИЙН ҮНДСЭН БАГШ, сум, дүүрэг, жилээр
    ## 206                                                                                                       ЕРӨНХИЙ БОЛОВСРОЛЫН СУРГУУЛИЙН ТОО, аймаг, нийслэл, жилээр
    ## 207                                                                                                          ЕРӨНХИЙ БОЛОВСРОЛЫН СУРГУУЛИЙН ТОО, сум, дүүрэг, жилээр
    ## 208                                                                                                                ЕРӨНХИЙ БОЛОВСРОЛЫН СУРГУУЛИЙН ТОО, төрөл, жилээр
    ## 209                                                                                    ЕРӨНХИЙ БОЛОВСРОЛЫН СУРГУУЛЬД ӨДРӨӨР СУРАЛЦАГЧДЫН ТОО, аймаг, нийслэл, жилээр
    ## 210                                                                                                         ЕРӨНХИЙ БОЛОВСРОЛЫН СУРГУУЛЬД ӨДРӨӨР СУРАЛЦАГЧИД, жилээр
    ## 211                                                  ЕРӨНХИЙ БОЛОВСРОЛЫН СУРГУУЛИЙН СУРАЛЦАГЧДААС ДОТУУР БАЙРАНД СУУХ ХҮСЭЛТ ГАРГАСАН ХҮҮХЭД, аймаг, нийслэл, жилээр
    ## 212                                                           ЕРӨНХИЙ БОЛОВСРОЛЫН СУРГУУЛИЙН СУРАЛЦАГЧДААС ДОТУУР БАЙРАНД АМЬДАРЧ БУЙ ХҮҮХЭД, аймаг, нийслэл, жилээр
    ## 213                                                                                               ЕБС-ИЙН НЭГДҮГЭЭР АНГИД ШИНЭЭР ЭЛСЭГЧДИЙН ТОО, сум, дүүрэг, жилээр
    ## 214                                                                                    ЕРӨНХИЙ БОЛОВСРОЛЫН СУРГУУЛИЙН СУРАГЧ-БАГШИЙН ХАРЬЦАА, аймаг, нийслэл, жилээр
    ## 215                                                                                    ЭЛСЭЛТИЙН ЕРӨНХИЙ ШАЛГАЛТЫН ДҮН (ХЭМЖЭЭСТ ОНОО), хүйс, аймаг, нийслэл, жилээр
    ## 216                                                                           ЕРӨНХИЙ БОЛОВСРОЛЫН СУРГУУЛИЙГ ӨДРӨӨР СУРАЛЦАН ТӨГСӨГЧИД, анги, аймаг, нийслэл, жилээр
    ## 217                                                                                       ЕРӨНХИЙ БОЛОВСРОЛЫН СУРГУУЛЬД ӨДРӨӨР СУРАЛЦАГЧДЫН ТОО, сум, дүүрэг, жилээр
    ## 218                                                                                    ЕРӨНХИЙ БОЛОВСРОЛЫН СУРГУУЛИЙГ ӨДРӨӨР СУРАЛЦАН ТӨГСӨГЧИД, сум, дүүрэг, жилээр
    ## 219                                                                 ЕРӨНХИЙ БОЛОВСРОЛЫН СУРГУУЛЬД СУРАЛЦДАГ ХӨГЖЛИЙН БЭРХШЭЭЛТЭЙ СУРАЛЦАГЧИД, аймаг, нийслэл, жилээр
    ## 220                                                                                                ЕРӨНХИЙ БОЛОВСРОЛЫН СУРГУУЛИЙН ҮНДСЭН БАГШ, өмчийн хэлбэр, жилээр
    ## 221                                                                                                     НЭГДҮГЭЭР АНГИД ЭЛСЭГЧДИЙН ЭЛСЭЛТИЙН ЦЭВЭР ЖИН, хүйс, жилээр
    ## 222                                                                                                    БАГА АНГИ ТӨГСӨГЧДИЙН БОХИР ЖИН, хүйс, аймаг, нийслэл, жилээр
    ## 223                                                                                                   ХАМРАН СУРГАЛТЫН БОХИР ЖИН, хүйс, анги, аймаг, нийслэл, жилээр
    ## 224                                                                                                            БОЛОВСРОЛЫН САЛБАРЫН ЗАРДАЛ, төрөл, жилээр, оны үнээр
    ## 225                                                                                                     БYХ ШАТНЫ БОЛОВСРОЛЫН СУРГАЛТЫН БАЙГУУЛЛАГА, ангилал, жилээр
    ## 226                                                                                                    БҮХ ШАТНЫ СУРГАЛТЫН БАЙГУУЛЛАГЫН ҮНДСЭН БАГШ, ангилал, жилээр
    ## 227                                                                                                      БYХ ШАТНЫ СУРГАЛТЫН БАЙГУУЛЛАГЫГ ТӨГСӨГЧИД, ангилал, жилээр
    ## 228                                                                                        БYХ ШАТНЫ БОЛОВСРОЛЫН СУРГАЛТЫН БАЙГУУЛЛАГАД СУРАЛЦАГЧИД, ангилал, жилээр
    ## 229                                                           ЭРҮҮЛ МЭНДИЙН ДААТГАЛЫН САНГИЙН ОРЛОГО, ЭМДС-ЫН ТУСЛАМЖ ҮЙЛЧИЛГЭЭНИЙ ЗАРДАЛ, төрөл, сараар (өссөн дүн)
    ## 230                                                                                                                     ЭРҮҮЛ МЭНДИЙН ДААТГАЛД ДААТГУУЛАГЧИД, сараар
    ## 231                                                                                                   ЭРҮҮЛ МЭНДИЙН ДААТГАЛЫН САНГИЙН ОРЛОГО, ЗАРЛАГА, төрөл, жилээр
    ## 232                                     ЭРҮҮЛ МЭНДИЙН ДААТГАЛЫН САНГААС ҮНИЙН ХӨНГӨЛӨЛТ ҮЗҮҮЛДЭГ ЗАЙЛШГҮЙ ШААРДЛАГАТАЙ ЭМИЙН БОРЛУУЛАЛТ, эмийн ерөнхий бүлэг, жилээр
    ## 233                                                                                                                     ЭРҮҮЛ МЭНДИЙН ДААТГАЛД ДААТГУУЛАГЧИД, жилээр
    ## 234                                                                                                 ЭРҮҮЛ МЭНДИЙН БАЙГУУЛЛАГЫН АЖИЛЛАГЧИД, мэргэжлийн чиглэл, жилээр
    ## 235                                                                        ЭМНЭЛЭГТ ХЭВТЭН ЭМЧЛҮҮЛЭГЧИД, 10000 хүн амд ногдох, өвчлөлийн зонхилох 10 ангилал, жилээр
    ## 236                                                                                                             ЭМНЭЛЭГТ ХЭВТЭН ЭМЧЛҮҮЛЭГЧИД, аймаг, нийслэл, сараар
    ## 237                                                                                                                                  ЭМНЭЛГИЙН ОРНЫ ТОО, сум, жилээр
    ## 238                                                                                                                      ЭМНЭЛГИЙН ОР, төрөл, аймаг, нийслэл, жилээр
    ## 239                                                                                                                            ИХ ЭМЧИЙН ТОО, бүс, аймаг, нийслэлээр
    ## 240                                                                                                                                       ИХ ЭМЧИЙН ТОО, сум, жилээр
    ## 241                                                                                                                          ЭМ ЗҮЙЧДИЙН ТОО, аймаг, нийслэл, жилээр
    ## 242                                                                                                      ТАЙЛАН ИРҮҮЛСЭН ЭРҮҮЛ МЭНДИЙН БАЙГУУЛЛАГЫН ТОО, сум, жилээр
    ## 243                                                                                                            НЭГ ИХ ЭМЧИД НОГДОХ ХҮНИЙ ТОО, аймаг, нийслэл, жилээр
    ## 244                                                                                                          НЭГ СУВИЛАГЧИД НОГДОХ ХҮНИЙ ТОО, аймаг, нийслэл, жилээр
    ## 245                                                                                                                       СУВИЛАГЧ, мэргэжил, аймаг, нийслэл, жилээр
    ## 246                                                                                                              ЭМНЭЛГИЙН ТУСГАЙ МЭРГЭЖИЛТЭН, мэргэжил, сум, жилээр
    ## 247                                                                                                                            ЭРҮҮЛ МЭНДИЙН САЛБАРЫН ЗАРДАЛ, жилээр
    ## 248                                                                      НЭГ ХҮРТЭЛХ НАСНЫ ХҮҮХДИЙН ӨРГӨН ДАРХЛААЖУУЛАЛТАД ХАМРАГДАЛТ, төрөл, аймаг, нийслэл, жилээр
    ## 249                                                           ЭРҮҮЛ МЭНДИЙН ДААТГАЛЫН САНГИЙН ОРЛОГО, ЭМДС-ЫН ТУСЛАМЖ ҮЙЛЧИЛГЭЭНИЙ ЗАРДАЛ, төрөл, сараар (өссөн дүн)
    ## 250                                                                                                              ЭРҮҮЛ МЭНДИЙН CАЛБАРЫН УДИРДАХ АЖИЛТАН, сум, жилээр
    ## 251                                                                                                                                      ЭМ ЗҮЙЧИЙН ТОО, сум, жилээр
    ## 252                                                                             СУРГУУЛИЙН ӨМНӨХ БОЛОВСРОЛЫН БАЙГУУЛЛАГЫН ҮНДСЭН БАГШИЙН ТОО, аймаг, нийслэл, жилээр
    ## 253                                                                               СУРГУУЛИЙН ӨМНӨХ БОЛОВСРОЛЫН БАЙГУУЛЛАГЫН АЖИЛЛАГЧИД, хүйс, аймаг, нийслэл, жилээр
    ## 254                                                                                                                          ЦЭЦЭРЛЭГИЙН ТОО, аймаг, нийслэл, жилээр
    ## 255                                                                                                                             ЦЭЦЭРЛЭГИЙН ТОО, сум, дүүрэг, жилээр
    ## 256                                                                        СУРГУУЛИЙН ӨМНӨХ БОЛОВСРОЛЫН БАЙГУУЛЛАГАД ХАМРАГДСАН ХҮҮХДИЙН ТОО, аймаг, нийслэл, жилээр
    ## 257                                                                                                                           ЦЭЦЭРЛЭГИЙН ТОО, өмчийн хэлбэр, жилээр
    ## 258                                                                                                            СУРГУУЛИЙН ӨМНӨХ БОЛОВСРОЛД ХАМРАГДСАН ХҮҮХЭД, жилээр
    ## 259                                                                                               СУРГУУЛИЙН ӨМНӨХ БАЙГУУЛЛАГЫН АЖИЛЛАГЧДЫН ТОО, сум, дүүрэг, жилээр
    ## 260                                                   СУРГУУЛИЙН ӨМНӨХ БОЛОВСРОЛЫН БАЙГУУЛЛАГАД ХАМРАГДСАН ХӨГЖЛИЙН БЭРХШЭЭЛТЭЙ ХҮҮХЭД, хүйс, аймаг, нийслэл, жилээр
    ## 261                                                                                               СУРГУУЛИЙН ӨМНӨХ БОЛОВСРОЛД ХАМРАГДСАН ХҮҮХЭД, сум, дүүрэг, жилээр
    ## 262                                                                                            ИХ, ДЭЭД СУРГУУЛЬ, КОЛЛЕЖИД СУРАЛЦАГЧИД, хүйс, аймаг, нийслэл, жилээр
    ## 263                                                                                               ИХ, ДЭЭД СУРГУУЛЬ, КОЛЛЕЖИД СУРАЛЦАГЧИД, мэргэжлийн чиглэл, жилээр
    ## 264                                                                                                ИХ, ДЭЭД СУРГУУЛЬ, КОЛЛЕЖИЙГ ТӨГСӨГЧИД, мэргэжлийн чиглэл, жилээр
    ## 265                                                                                   ДЭЭД БОЛОВСРОЛЫН СУРГАЛТЫН БАЙГУУЛЛАГАД СУРАЛЦАГЧИД, боловсролын зэрэг, жилээр
    ## 266                                                                                                    ИХ, ДЭЭД СУРГУУЛЬ, КОЛЛЕЖИЙН ҮНДСЭН БАГШИЙН ТОО, хүйс, жилээр
    ## 267                                                                                 ИХ, ДЭЭД СУРГУУЛЬ, КОЛЛЕЖИЙГ ТӨГСӨГЧИД, өмчийн хэлбэр, боловсролын зэрэг, жилээр
    ## 268                                                                    ДОТООДЫН ИХ, ДЭЭД СУРГУУЛЬ, КОЛЛЕЖИЙГ ТӨГСӨГЧИД, мэргэжлийн чиглэл, боловсролын зэрэг, жилээр
    ## 269                                                                   ДОТООДЫН ИХ, ДЭЭД СУРГУУЛЬ, КОЛЛЕЖИД СУРАЛЦАГЧИД, мэргэжлийн чиглэл, боловсролын зэрэг, жилээр
    ## 270                                                          ТЕХНИКИЙН БОЛОН МЭРГЭЖЛИЙН БОЛОВСРОЛЫН СУРГАЛТЫН БАЙГУУЛЛАГАД СУРАЛЦАГЧИД, хүйс, аймаг, нийслэл, жилээр
    ## 271                                                                         ТЕХНИКИЙН БОЛОН МЭРГЭЖЛИЙН БОЛОВСРОЛЫН СУРГАЛТЫН БАЙГУУЛЛАГЫН ТОО, өмчийн хэлбэр, жилээр
    ## 272                                                                          ТЕХНИКИЙН БОЛОН МЭРГЭЖЛИЙН БОЛОВСРОЛЫН СУРГАЛТЫН БАЙГУУЛЛАГЫН ҮНДСЭН БАГШ, хүйс, жилээр
    ## 273                                               ТЕХНИКИЙН БОЛОН МЭРГЭЖЛИЙН БОЛОВСРОЛЫН СУРГАЛТЫН БАЙГУУЛЛАГЫН АЖИЛЛАГЧИД БОЛОН ҮНДСЭН БАГШ, аймаг, нийслэл, жилээр
    ## 274                                              ТЕХНИКИЙН БОЛОН МЭРГЭЖЛИЙН БОЛОВСРОЛ, СУРГАЛТЫН БАЙГУУЛЛАГЫГ ТӨГСӨГЧИД, мэргэжлийн чиглэл, сургалтын чиглэл, жилээр
    ## 275                                                 ТЕХНИКИЙН БОЛОН МЭРГЭЖЛИЙН БОЛОВСРОЛ, СУРГАЛТЫН БАЙГУУЛЛАГЫГ ТӨГСӨГЧИД, сургалтын чиглэл, аймаг, нийслэл, жилээр
    ## 276                                                              ТЕХНИКИЙН БОЛОН МЭРГЭЖЛИЙН БОЛОВСРОЛЫН СУРГАЛТЫН БАЙГУУЛЛАГАД СУРАЛЦАГЧИД, сургалтын чиглэл, жилээр
    ## 277                                            ТЕХНИКИЙН БОЛОН МЭРГЭЖЛИЙН БОЛОВСРОЛ, СУРГАЛТЫН БАЙГУУЛЛАГАД СУРАЛЦАГЧИД, мэргэжлийн чиглэл, сургалтын чиглэл, жилээр
    ## 278                                                                                                                БНМАУ-ЫН ЗАСАГ ЗАХИРГАА, НУТАГ ДЭВСГЭРИЙН ХУВААРЬ
    ## 279                                                                                                           БНМАУ-ЫН ЗАСАГ ЗАХИРГААНЫ ЗОХИОН БАЙГУУЛАЛТЫН ӨӨРЧЛӨЛТ
    ## 280                                                                                                                          ХӨДӨӨ АЖ АХУЙН ҮЙЛДВЭРЛЭЛИЙН ГАЗРЫН ТОО
    ## 281                                                                                                                                  МАХ, НООСНЫ ҮЙЛДВЭРЛЭЛТ, жилээр
    ## 282                                                                                                                             ХӨДӨӨ АЖ АХУЙН ЭДЭЛБЭР ГАЗАР, мян.га
    ## 283                                                                                                                                        ТАРИАЛСАН ТАЛБАЙ /мян.га/
    ## 284                                                                                                                      ХУРААН АВСАН УРГАЦ, УРГАМЛЫН ТӨРЛӨӨР, мян.т
    ## 285                                                                                                                     НЭГ ГА-ГИЙН УРГАЦ, ургамлын төрлөөр, центнер
    ## 286                                                                                                                                                ХАДСАН ӨВС, мян.т
    ## 287                                                                                                                                       МАЛЫН ХАШААНЫ ТОО, мян.шир
    ## 288                                                                                                                           ӨРӨМДМӨЛ, УУРХАЙН ХУДГИЙН ТОО, мян.шир
    ## 289                                                                                                   УЛСЫН БЭЛТГЭЛД ТУШААСАН НЭГ ТОЛГОЙ МАЛЫН АМЬДЫН ДУНДАЖ ЖИН, кг
    ## 290                                                                                                                                     МАЛ ЭМНЭЛГИЙН БОЛОВСОН ХҮЧИН
    ## 291                                                                                                             ХӨДӨӨ АЖ АХУЙН НИЙТ БҮТЭЭГДЭХҮҮН, оны үнээр, сая төг
    ## 292                                                                                                                  МАЛЫН ТОО, аж ахуйн салбараар, төрлөөр, мян.тол
    ## 293                                                                                                                                                        МАЛЫН ТОО
    ## 294                                                                                                                                                      ТӨЛ БОЙЖИЛТ
    ## 295                                                                                                                             ХЭЭЛТЭГЧ МАЛЫН ТОО, төрлөөр, мян.тол
    ## 296                                                                                                                                      ГАХАЙ, ШУВУУНЫ ТОО, мян.тол
    ## 297                                                                                                           ХӨДӨӨ АЖ АХУЙН ГОЛ НЭР ТӨРЛИЙН БҮТЭЭГДЭХҮҮН ҮЙЛДВЭРЛЭЛ
    ## 298                                                                                                                                               НЭГ МАЛЫН АШИГ ШИМ
    ## 299                                                                                                                                         БҮХ ШАТНЫ СУРГУУЛИЙН ТОО
    ## 300                                                                                                                                         СУРАЛЦАГЧДЫН ТОО, жилээр
    ## 301                                                                                                                            БНМАУ-ЫН ДЭЭД СУРГУУЛИУДЫН ОЮУТНЫ ТОО
    ## 302                                                                                                                        ЕРӨНХИЙ БОЛОВСРОЛЫН ӨДРИЙН СУРГУУЛИЙН ТОО
    ## 303                                                                                                  ЕРӨНХИЙ БОЛОВСРОЛЫН ӨДРИЙН СУРГУУЛЬД СУРАЛЦАГЧИД, аймаг, хотоор
    ## 304                                                                                                         ЕРӨНХИЙ БОЛОВСРОЛЫН ӨДРИЙН СУРГУУЛЬД ЭЛСЭГЧИД, ТӨГСӨГЧИД
    ## 305                                                                                                                               БАГШ НАРЫН ТОО, СУРГУУЛИЙН ТӨРЛӨӨР
    ## 306                                                                                                                                             ЦЭЦЭРЛЭГ, ЯСЛИЙН ТОО
    ## 307                                                                                                           ЭРДЭМ ШИНЖИЛГЭЭНИЙ БАЙГУУЛЛАГА, АЖИЛТНЫ ТОО, оны эцэст
    ## 308                                                                                                                                                  СЭТГҮҮЛ ГАРГАЛТ
    ## 309                                                                                                                                                    СОНИН ГАРГАЛТ
    ## 310                                                                                                                                              ҮЗВЭР ҮЗЭГЧДИЙН ТОО
    ## 311                                                                                                                                  СОЁЛ, УРЛАГИЙН БАЙГУУЛЛАГЫН ТОО
    ## 312                                                                                                         АЖ ҮЙЛДВЭРИЙН НИЙТ БҮТЭЭГДЭХҮҮН, салбар, оны үнэ, сараар
    ## 313                                                                                          АЖ ҮЙЛДВЭРИЙН НИЙТ БҮТЭЭГДЭХҮҮН, салбар, 1967 оны үл хөдлөх үнэ, жилээр
    ## 314                                                                                           АЖ ҮЙЛДВЭРИЙН ГОЛ НЭР ТӨРЛИЙН БҮТЭЭГДЭХҮҮНИЙ ҮЙЛДВЭРЛЭЛ, төрөл, жилээр
    ## 315                                                                                                    АЖ ҮЙЛДВЭРИЙН САЛБАРЫН АЖИЛЛАГЧДЫН ДУНДАЖ ТОО, салбар, жилээр
    ## 316                                                                                                                            ЦАХИЛГААН ЭРЧИМ ХҮЧНИЙ БАЛАНС, жилээр
    ## 317                                                                                                                                          НҮҮРСНИЙ БАЛАНС, жилээр
    ## 318                                                                                                     АЖ ҮЙЛДВЭРИЙН САЛБАРТ АЖИЛЛАГЧДЫН ДУНДАЖ ТОО, салбар, жилээр
    ## 319                                                                                                                 АМРАЛТ, РАШААН, СУВИЛАЛД АМРАГЧДЫН ТОО (мян.хүн)
    ## 320                                                                                                                       БОЛЬНИЦЫН ТӨРЛИЙН ЭМНЭЛГИЙН ОРНЫ ТӨРӨЛЖИЛТ
    ## 321                                                                                                                        ХҮН ЭМНЭЛГИЙН ДУНД МЭРГЭЖЛИЙН АЖИЛТНЫ ТОО
    ## 322                                                                                                                                                    ИХ ЭМЧИЙН ТОО
    ## 323                                                                                           ДОТООДЫН НИЙТ БҮТЭЭГДЭХҮҮН, 1995 оны зэрэгцүүлэх үнээр, салбар, жилээр
    ## 324                                                                                                                   УЛС АРДЫН АЖ АХУЙН ҮНДСЭН ФОНД, салбар, жилээр
    ## 325                                                            ХӨДӨЛМӨРИЙН БҮТЭЭМЖ /НЭГ АЖИЛЛАГЧИД НОГДОХ ҮНДЭСНИЙ ОРЛОГО/, 1986 оны зэрэгцүүлэх үнэ, салбар, жилээр
    ## 326                                                                                                      Нийгмийн нийт бүтээгдэхүүн, салбараар, оны үнээр,сая төгрөг
    ## 327                                                                         Нийгмийн нийт бүтээгдэхүүн, салбараар, 1986 оны зэрэгцүүлэх үнээр, оны үнээр, сая төгрөг
    ## 328                                                                                     Үндэсний орлого, салбараар,1986 оны зэрэгцүүлэх үнээр, оны үнээр, сая төгрөг
    ## 329                                                                                                     Дотоодын нийт бүтээгдэхүүн, салбараар, оны үнээр, сая төгрөг
    ## 330                                                                                                                Үндэсний орлого, салбараар, оны үнээр, сая төгрөг
    ## 331                                                                                                                       Барилга угсралтын ажлын хэмжээ, сая төгрөг
    ## 332                                                                                                                      Ашиглалтанд оруулсан орон сууц, мянган кв.м
    ## 333                                                                                                          Барилгын ажилчин, албан хаагчдын дундаж тоо, мянган хүн
    ## 334                                                                                                               Барилгын салбарын үндсэн фонд, төрлөөр, сая төгрөг
    ## 335                                                      Улс ардын аж ахуйн хөрөнгө оруулалтын нийт хэмжээ, санхүүжилтийн эх үүсвэр, технологийн бүтцээр, сая төгрөг
    ## 336                                                                                                         АШИГЛАЛТАД ОРУУЛСАН ҮНДСЭН ФОНД, салбар, оны үнэ, жилээр
    ## 337                                                                                         Улс ардын аж ахуйн хөрөнгө оруулалтын нийт хэмжээ, салбараар, сая төгрөг
    ## 338                                                                                                                           ХӨДӨЛМӨРИЙН НАСНЫ ХҮН АМЫН ТОО, жилээр
    ## 339                                                                                                                           УЛС, АРДЫН АЖ АХУЙД АЖИЛЛАГЧИД, жилээр
    ## 340                                                                                            УЛС АРДЫН АЖ АХУЙН АЖИЛЧИН, АЛБАН ХААГЧДЫН ДУНДАЖ ТОО, салбар, жилээр
    ## 341                                                                               УЛС АРДЫН АЖ АХУЙД АЖИЛЛАЖ БАЙГАА ДЭЭД, ТУСГАЙ ДУНД БОЛОВСРОЛТОЙ ХҮНИЙ ТОО, жилээр
    ## 342                                                                                                                               НИЙТ ХҮН АМЫН ТОО, байршил, жилээр
    ## 343                                                                                                                                             ТӨРӨЛТ, хүйс, жилээр
    ## 344                                                                                                                                         НАС БАРАЛТ, хүйс, жилээр
    ## 345                                                                                                                      1000 ХҮНД НОГДОХ ЕРДИЙН ЦЭВЭР ӨСӨЛТ, жилээр
    ## 346                                                                                                           ХҮН АМЫН ҮНДЭСНИЙ БҮРЭЛДЭХҮҮН, дүнд эзлэх хувь, жилээр
    ## 347                                                                                                                                  ХҮН АМЫН НИЙГМИЙН ГАРАЛ, жилээр
    ## 348                                                                                                                                 1000 ХҮНД НОГДОХ ГЭРЛЭЛТ, жилээр
    ## 349                                                                                                                                 1000 ХҮНД НОГДОХ ЦУЦЛАЛТ, жилээр
    ## 350                                                                                                                            ХҮН АМЫН ДУНДАЖ НАСЛАЛТ, хүйс, жилээр
    ## 351                                                                                                                             ХҮН АМЫН БИЧИГ ҮСГИЙН МЭДЛЭГ, жилээр
    ## 352                                                                                                                                ХҮН АМЫН ТОО, насны бүлэг, жилээр
    ## 353                                                                                                                                    ХҮН АМЫН БОДИТ ОРЛОГО, жилээр
    ## 354                                                                                                      АЖИЛЧИН, АЛБАН ХААГЧДЫН САРЫН ДУНДАЖ ЦАЛИН, оны үнэ, жилээр
    ## 355                                                                                                         ОЛОН ХҮҮХЭДТЭЙ ЭХЧҮҮДЭД ОЛГОСОН УЛСЫН ТЭТГЭМЖ, оны үнээр
    ## 356                                                                                                                            ӨНДӨР НАСНЫ ТЭТГЭВЭР, оны үнэ, жилээр
    ## 357                                                                                                                            ХҮН АМЫН ХАДГАЛАМЖ, оны үнээр, жилээр
    ## 358                                                                              НЭГ ХҮН АМД НОГДОХ ХҮНСНИЙ ЗАРИМ НЭР ТӨРЛИЙН БҮТЭЭГДЭХҮҮНИЙ ХЭРЭГЛЭЭ, төрөл, жилээр
    ## 359                                                                                                                           УЛСЫН НЭГДСЭН ТӨСӨВ, оны үнээр, жилээр
    ## 360                                                                                                       УЛСЫН НЭГДСЭН ТӨСВИЙН БҮТЭЦ, дүнд харьцуулсан хувь, жилээр
    ## 361                                                                                                         ИМПОРТООР АВСАН ГОЛ НЭР ТӨРЛИЙН БАРАА, нэр төрөл, жилээр
    ## 362                                                                                                             ЭКСПОРТЫН ЗАРИМ НЭР ТӨРЛИЙН БАРАА, нэр төрөл, жилээр
    ## 363                                                                                                                            ГАДААД ХУДАЛДААНЫ НИЙТ ЭРГЭЛТ, жилээр
    ## 364                                                                       БНМАУ-ЫН ЭКСПОРТ, ИМПОРТЫН НИЙТ ХЭМЖЭЭНД СОЦИАЛИСТ, КАПИТАЛИСТ ОРНУУДЫН ЭЗЛЭХ ХУВЬ, жилээр
    ## 365                                                                                            НЭГ ХҮН АМД НОГДОХ ХУДАЛДСАН ГОЛ НЭР ТӨРЛИЙН БАРАА, нэр төрөл, жилээр
    ## 366                                                                                                      ЖИЖИГЛЭН ХУДАЛДСАН ГОЛ НЭР ТӨРЛИЙН БАРАА, нэр төрөл, жилээр
    ## 367                                                                                                               ЖИЖИГЛЭН ХУДАЛДСАН БАРАА ГҮЙЛГЭЭНИЙ ХЭМЖЭЭ, жилээр
    ## 368                                                                                                                            НИЙТИЙН ХООЛНЫ БАРАА, ГҮЙЛГЭЭ, жилээр
    ## 369                                                                                                             ЖИЖИГЛЭН ХУДАЛДАА, НИЙТИЙН ХООЛНЫ ГАЗРЫН ТОО, жилээр
    ## 370                                                                                            УЛС, ХОРШООЛЛЫН ЖИЖИГЛЭН ХУДАЛДААНЫ БАРАА ГҮЙЛГЭЭ, аймаг, хот, жилээр
    ## 371                                                                                                                БҮХ ТӨРЛИЙН АЧАА ЭРГЭЛТ, тээврийн төрлөөр, жилээр
    ## 372                                                                                                       БҮХ ТӨРЛИЙН ТЭЭВРЭЭР ТЭЭСЭН АЧАА, тээврийн төрлөөр, жилээр
    ## 373                                                                                                    БҮХ ТӨРЛИЙН ТЭЭВРИЙН ЗОРЧИГЧ ЭРГЭЛТ, тээврийн төрлөөр, жилээр
    ## 374                                                                                                  БҮХ ТӨРЛИЙН ТЭЭВРИЙН ЗОРЧИГЧ ТЭЭВЭРЛЭЛТ, тээврийн төрөл, жилээр
    ## 375                                                                                                                       АВТОМАШИН, ТЭЭВРИЙН ХЭРЭГСЛИЙН ТОО, жилээр
    ## 376                                                                                                                               САЙЖРУУЛСАН АВТО ЗАМЫН УРТ, жилээр
    ## 377                                                                                                                     ХОЛБООНЫ САЛБАРЫН ҮНДСЭН ҮЗҮҮЛЭЛТҮҮД, жилээр
    ## 378                                                                                                                   ХОЛБООНЫ СОЛИЛЦООНЫ ҮНДСЭН ҮЗҮҮЛЭЛТҮҮД, жилээр
    ## 379                                                                                                                  НИЙТИЙН АЖ АХУЙ, ҮЙЛЧИЛГЭЭНИЙ ЦЭГ, САЛБАРЫН ТОО
    ## 380                                                                                         НИЙТИЙН АЖ АХУЙ, ҮЙЛЧИЛГЭЭНИЙ ОРЛОГЫН ХЭМЖЭЭ, оны үнээр, төрлөөр, жилээр
    ## 381                                                                                                                         УЛС, ХОРШООЛЛЫН ОРОН СУУЦНЫ ФОНД, жилээр
    ## 382                                                                                                             ТАРИАЛСАН ТАЛБАЙ, ургамлын төрөл, баг, хороо, жилээр
    ## 383                                                                                                           ХУРААСАН УРГАЦ, ургамлын төрөл, аймаг, нийслэл, жилээр
    ## 384                                                                                                               ХУРААСАН УРГАЦ, ургамлын төрөл, баг, хороо, жилээр
    ## 385                                                                                                         ТАРИАЛСАН ТАЛБАЙ, ургамлын төрөл, аймаг, нийслэл, жилээр
    ## 386                                                                                НЭГ ГА ХУРААСАН ТАЛБАЙГААС ХУРААСАН УРГАЦ, ургамлын төрөл, аймаг, нийслэл, жилээр
    ## 387                                                                                                              ГАЗАР ТАРИАЛАНГИЙН САЛБАРЫН НИЙТ ҮЙЛДВЭРЛЭЛ, жилээр
    ## 388                                                                                                             ТАРИАЛАН ЭРХЭЛДЭГ ӨРХИЙН ТОО, аймаг, нийслэл, жилээр
    ## 389                                                                              ГАЗАР ТАРИАЛАНГИЙН БҮТЭЭГДЭХҮҮНИЙ ЗАХ ЗЭЭЛИЙН ДУНДАЖ ҮНЭ, аймаг, нийслэлээр, сараар
    ## 390                                                                                            БООДОЛТОЙ ӨВС, ХИВЭГНИЙ ЗАХ ЗЭЭЛИЙН ДУНДАЖ ҮНЭ, сум, дүүргээр, сараар
    ## 391                                                                                                                                     ХӨДӨӨ АЖ АХУЙН ГАЗАР, жилээр
    ## 392                                                                                                                    НИЙТ ТАРИАЛСАН ТАЛБАЙ, аймаг, нийслэл, жилээр
    ## 393                                                    ТАРИАЛСАН ТАЛБАЙ, ҮР ТАРИА , БУУДАЙ, ХҮНСНИЙ НОГОО, ТЭЖЭЭЛИЙН УРГАМАЛ, ургамлын төрөл, аймаг, нийслэл, жилээр
    ## 394                                                                         ХУРААСАН УРГАЦ, ҮР ТАРИА, ТӨМС, ХҮНСНИЙ НОГОО, ТЭЖЭЭЛИЙН УРГАМАЛ, аймаг, нийслэл, жилээр
    ## 395                                                                                         НЭГ ГА ТАЛБАЙГААС ХУРААСАН УРГАЦ, ургамлын төрөл, аймаг, нийслэл, жилээр
    ## 396                                                                                                                     БЭЛТГЭСЭН ӨВС ХАДЛАН, аймаг, нийслэл, жилээр
    ## 397                                                                                                                     БЭЛТГЭСЭН ГАР ТЭЖЭЭЛ, аймаг, нийслэл, жилээр
    ## 398                                                                                         ЖИМС, ЖИМСГЭНИЙ ТАРИАЛСАН ТАЛБАЙ, ургамлын төрөл, аймаг, нийслэл, жилээр
    ## 399                                                                                           ЖИМС, ЖИМСГЭНИЙ ХУРААСАН УРГАЦ, ургамлын төрөл, аймаг, нийслэл, жилээр
    ## 400                                                                                             ЖИМС, ЖИМСГЭНИЙ ТАРИАЛСАН ТАЛБАЙ, ургамлын төрөл, баг, хороо, жилээр
    ## 401                                                                                           ЖИМС ЖИМСГЭНИЙ НИЙТ БУТ, МОДНЫ ТОО, ургамлын төрөл, баг, хороо, жилээр
    ## 402                                                                                        ТАРИАЛАН ЭРХЭЛДЭГ АЖ АХУЙН НЭГЖ, БАЙГУУЛЛАГЫН ТОО, аймаг, нийслэл, жилээр
    ## 403                                                                          БАРИЛГА УГСРАЛТ, ИХ ЗАСВАРЫН АЖИЛ, барилгын төрөл, аймаг, нийслэл, улирлаар (өссөн дүн)
    ## 404                                                            БАРИЛГЫН БАЙГУУЛЛАГЫН АЖЛЫН БҮЛЭГЛЭЛТ, гүйцэтгэсэн барилга, угсралт, их засварын ажлын хэмжээ, жилээр
    ## 405                                                                                                 БАРИЛГА УГСРАЛТ, ИХ ЗАСВАРЫН АЖЛЫН БҮТЭЦ, барилгын төрөл, жилээр
    ## 406                                                                                             АШИГЛАЛТАД ОРУУЛСАН ҮНДСЭН ФОНД, барилгын төрөл, хүчин чадал, жилээр
    ## 407                                                    БАРИЛГЫН БАЙГУУЛЛАГЫН ГҮЙЦЭТГЭСЭН БАРИЛГА УГСРАЛТ, ИХ ЗАСВАРЫН АЖИЛ, байгууллагын төрөл, улирлаар (өссөн дүн)
    ## 408                                                                                          АШИГЛАЛТАД ОРУУЛСАН ҮНДСЭН ФОНД, барилгын төрөл, аймаг, нийслэл, жилээр
    ## 409                                                                                                                БАРИЛГЫН ӨРТГИЙН ИНДЕКС, барилгын төрөл, улирлаар
    ## 410                                                                                                                                    СОЁЛЫН ЗАРИМ ҮЗҮҮЛЭЛТ, жилээр
    ## 411                                                                                                                           НИЙТИЙН НОМЫН САНГИЙН ҮЗҮҮЛЭЛТ, жилээр
    ## 412                                                                                    НИЙТИЙН НОМЫН САН, БАЙНГЫН УНШИГЧИД, НОМЫН ФОНДНЫ ТОО, аймаг, нийслэл, жилээр
    ## 413                                                                                                                 КИНО ҮЗВЭРИЙН ЦЭГИЙН ТОО, аймаг, нийслэл, жилээр
    ## 414                                                                                                              СОЁЛЫН ТӨВ, АЖИЛЛАГЧДЫН ТОО, аймаг, нийслэл, жилээр
    ## 415                                                                                                              МУЗЕЙН ҮЗМЭР, ҮЗЭГЧДИЙН ТОО, аймаг, нийслэл, жилээр
    ## 416                                                                                  МЭРГЭЖЛИЙН УРЛАГИЙН БАЙГУУЛЛАГЫН ТОГЛОЛТ, ҮЗЭГЧДИЙН ТОО, аймаг, нийслэл, жилээр
    ## 417                                                                                                        НИЙТИЙН НОМЫН САНГИЙН СУУДЛЫН ТОО, аймаг, нийслэл, жилээр
    ## 418                                                                                                                СОЁЛЫН ТӨВИЙН СУУДЛЫН ТОО, аймаг, нийслэл, жилээр
    ## 419                                                                                   СОЁЛ, УРЛАГЫН БАЙГУУЛЛАГЫН АЖИЛЛАГЧДЫН ТОО, соёл, урлагийн байгууллага, жилээр
    ## 420                                                                                  АЖ ҮЙЛДВЭРИЙН САЛБАРЫН НИЙТ ҮЙЛДВЭРЛЭЛ, улсын дүнгээр, сараар (2003.01-2020.06)
    ## 421                                                                                                    АЖ ҮЙЛДВЭРИЙН САЛБАРЫН НИЙТ ҮЙЛДВЭРЛЭЛ, дэд салбараар, сараар
    ## 422                                                                                          АЖ ҮЙЛДВЭРИЙН САЛБАРЫН НИЙТ ҮЙЛДВЭРЛЭЛИЙН БҮТЭЦ*, дэд салбараар, жилээр
    ## 423                                                                                      АЖ ҮЙЛДВЭРИЙН САЛБАРЫН БҮТЭЭГДЭХҮҮНИЙ БОРЛУУЛАЛТ, аймаг, нийслэлээр, жилээр
    ## 424                                                                          АЖ ҮЙЛДВЭРИЙН САЛБАРЫН ГОЛ НЭР ТӨРЛИЙН БҮТЭЭГДЭХҮҮНИЙ ҮЙЛДВЭРЛЭЛ, улсын дүнгээр, сараар
    ## 425                                                                       АЖ ҮЙЛДВЭРИЙН САЛБАРЫН БҮТЭЭГДЭХҮҮНИЙ БОРЛУУЛАЛТ, дэд салбараар, сараар (2001.01-2020.06.)
    ## 426                                                                                НЭГ ХҮНД НОГДОХ АЖ ҮЙЛДВЭРИЙН ЗАРИМ НЭР ТӨРЛИЙН БҮТЭЭГДЭХҮҮНИЙ ҮЙЛДВЭРЛЭЛ, жилээр
    ## 427                                                                                                                            ЦАХИЛГААН ЭРЧИМ ХҮЧНИЙ ТЭНЦЭЛ, жилээр
    ## 428                                                                                                                                          НҮҮРСНИЙ ТЭНЦЭЛ, жилээр
    ## 429                                                                                                                                           ДУЛААНЫ ТЭНЦЭЛ, жилээр
    ## 430                                                                                         АЖ ҮЙЛДВЭРИЙН САЛБАРЫН ГОЛ НЭР ТӨРЛИЙН БҮТЭЭГДЭХҮҮНИЙ ҮЙЛДВЭРЛЭЛ, жилээр
    ## 431                                                                 УЛИРЛЫН НӨЛӨӨЛЛИЙГ АРИЛГАСАН АЖ ҮЙЛДВЭРИЙН ҮЙЛДВЭРЛЭЛИЙН ИНДЕКС, 2010=100, дэд салбараар, сараар
    ## 432                                                                 УЛИРЛЫН НӨЛӨӨЛЛИЙГ АРИЛГАСАН АЖ ҮЙЛДВЭРИЙН ҮЙЛДВЭРЛЭЛИЙН ИНДЕКС, 2015=100, дэд салбараар, сараар
    ## 433                                                                                              АЖ ҮЙЛДВЭРИЙН ҮЙЛДВЭРЛЭЛИЙН ИНДЕКС, 2010=100, дэд салбараар, сараар
    ## 434                                                                              АЖ ҮЙЛДВЭРИЙН САЛБАРЫН ҮЙЛДВЭРЛЭГЧИЙН ҮНИЙН ИНДЕКС, 2015=100, дэд салбараар, сараар
    ## 435                                                                                              АЖ ҮЙЛДВЭРИЙН ҮЙЛДВЭРЛЭЛИЙН ИНДЕКС, 2015=100, дэд салбараар, сараар
    ## 436                                                                                          АЖ ҮЙЛДВЭРИЙН САЛБАРЫН БҮТЭЭГДЭХҮҮНИЙ БОРЛУУЛАЛТ, дэд салбараар, сараар
    ## 437                                                                                                                    МАЛ АЖ АХУЙН САЛБАРЫН НИЙТ ҮЙЛДВЭРЛЭЛ, жилээр
    ## 438                                                                                                                  БОЙЖУУЛСАН ТӨЛ, малын төрөл, баг, хороо, жилээр
    ## 439                                                                                                                 100 ЭХЭЭС БОЙЖУУЛСАН ТӨЛ, аймаг, нийслэл, жилээр
    ## 440                                                                                                            БОЙЖУУЛСАН ТӨЛ, малын төрөл, аймаг, нийслэл, улирлаар
    ## 441                                                                                                ТОМ МАЛЫН ЗҮЙ БУС ХОРОГДОЛ, малын төрөл, аймаг, нийслэл, улирлаар
    ## 442                                                                                                     ӨВЧНӨӨР ХОРОГДСОН МАЛЫН ТОО, малын төрөл, баг, хороо, жилээр
    ## 443                                                                                                  ХЭЭЛ ХАЯСАН ХЭЭЛТЭГЧ МАЛЫН ТОО, малын төрөл, баг, хороо, жилээр
    ## 444                                                                                                    СУВАЙРСАН ХЭЭЛТЭГЧ МАЛЫН ТОО, малын төрөл, баг, хороо, жилээр
    ## 445                                                                                                                               ГАХАЙН ТОО, аймаг, нийслэл, жилээр
    ## 446                                                                                                                              ШУВУУНЫ ТОО, аймаг, нийслэл, жилээр
    ## 447                                                                        НЭГ ХҮНД НОГДОХ ХӨДӨӨ АЖ АХУЙН ГОЛ НЭР ТӨРЛИЙН БҮТЭЭГДЭХҮҮН, бүтээгдэхүүний төрөл, жилээр
    ## 448                                                                                                                       МАЛЫН ТОО, малын төрөл, баг, хороо, жилээр
    ## 449                                                                                                              ХЭЭЛТЭГЧ МАЛЫН ТОО, малын төрөл, баг, хороо, жилээр
    ## 450                                                                                                       ТОМ МАЛЫН ЗҮЙ БУС ХОРОГДОЛ, малын төрөл баг, хороо, жилээр
    ## 451                                                                                                                  ТЭЖЭЭВЭР АМЬТДЫН ТОО, төрөл, баг, хороо, жилээр
    ## 452                                                                                    МАЛ АЖ АХУЙН БҮТЭЭГДЭХҮҮНИЙ ЗАХ ЗЭЭЛИЙН ДУНДАЖ ҮНЭ, аймаг, нийслэлээр, сараар
    ## 453                                                                                          ХӨДӨӨ АЖ АХУЙН БҮТЭЭГДЭХҮҮНИЙ ҮЙЛДВЭРЛЭЛ, төрөл, аймаг, нийслэл, жилээр
    ## 454                                                                                                              МАЛЫН ЗАХ ЗЭЭЛИЙН ДУНДАЖ ҮНЭ, сум, дүүргээр, сараар
    ## 455                                                                                                                                САРЛАГИЙН ТОО, баг, хороо, жилээр
    ## 456                                                                                                                  ШИНЖЛЭХ УХААНЫ САЛБАРЫН ҮНДСЭН ҮЗҮҮЛЭЛТ, жилээр
    ## 457                                                                                                             ЭРДМИЙН ЗЭРЭГ, ЦОЛТОЙ ҮНДСЭН АЖИЛЛАГЧДЫН ТОО, жилээр
    ## 458                                                                                    УЛСЫН ХИЛЭЭР ОРСОН ГАДААДЫН ЗОРЧИГЧДЫН ТОО, аяллын зорилго, бүс нутаг, жилээр
    ## 459                                                                                                        ГАДААДАД ЗОРЧСОН МОНГОЛ ИРГЭД, хүйс, зорилго, улс, жилээр
    ## 460                                                                             УЛСЫН ХИЛЭЭР ОРСОН ТЭЭВРИЙН ХЭРЭГСЛИЙН ТОО, боомт, тээврийн хэрэгслийн төрөл, жилээр
    ## 461                                                                                          УЛСЫН ХИЛЭЭР ОРСОН ЗОРЧИГЧИД, хүйс, насны бүлэг, аяллын зорилго, сараар
    ## 462                                                                            УЛСЫН ХИЛЭЭР ГАРСАН ТЭЭВРИЙН ХЭРЭГСЛИЙН ТОО, тээврийн хэрэгслийн төрөл, боомт, жилээр
    ## 463                                                                                         УЛСЫН ХИЛЭЭР ОРСОН ЗОРЧИГЧИД, хүйс, насны бүлэг, зорчсон хугацаа, сараар
    ## 464                                                                                         ГАДААДАД ЗОРЧСОН МОНГОЛ ИРГЭД, хүйс, насны бүлэг, аяллын зорилго, сараар
    ## 465                                                                                        ГАДААДАД ЗОРЧСОН МОНГОЛ ИРГЭД, хүйс, насны бүлэг, зорчсон хугацаа, сараар
    ## 466                                                                                                                ГАДААДАД ЗОРЧСОН МОНГОЛ ИРГЭДИЙН ТОО, улс, сараар
    ## 467                                                                                                       ХУДАЛДААНЫ САЛБАРЫН НИЙТ БОРЛУУЛАЛТ, дэд салбараар, жилээр
    ## 468                                                                                              ХУДАЛДААНЫ САЛБАРЫН НИЙТ БОРЛУУЛАЛТ, бүс, аймаг, нийслэлээр, сараар
    ## 469                                                                                              ХУДАЛДААНЫ САЛБАРЫН НИЙТ БОРЛУУЛАЛТ, бүс, аймаг, нийслэлээр, жилээр
    ## 470                                                                                                          БҮХ ТӨРЛИЙН ТЭЭВРИЙН ҮНДСЭН ҮЗҮҮЛЭЛТ, улсын дүн, жилээр
    ## 471                                                        ТЕХНИКИЙН ХЯНАЛТЫН ҮЗЛЭГТ ХАМРАГДСАН АВТО МАШИНЫ ТОО, төрлөөр, бүс, аймаг, нийслэл, сум, дүүргээр, жилээр
    ## 472                                                     ТЕХНИКИЙН ХЯНАЛТЫН ҮЗЛЭГТ ХАМРАГДСАН АВТО МАШИНЫ ТОО, насжилтаар, бүс, аймаг, нийслэл, сум, дүүргээр, жилээр
    ## 473                                                                                      БҮРТГЭЛТЭЙ ТЭЭВРИЙН ХЭРЭГСЛИЙН ТОО, төрлөөр, бүс, аймаг, нийслэлээр, жилээр
    ## 474                                                                                   БҮРТГЭЛТЭЙ ТЭЭВРИЙН ХЭРЭГСЛИЙН ТОО, насжилтаар, бүс, аймаг, нийслэлээр, жилээр
    ## 475                                                                                        ИМПОРТООР ОРУУЛЖ ИРСЭН АВТОМАШИНЫ ТОО, улсаар, автомашины төрлөөр, жилээр
    ## 476                                                                                                                 УЛС ТӨРИЙН АЛБАН ТУШААЛТНУУДЫН ТОО, хүйс, жилээр
    ## 477                                                                                                  ТӨРИЙН ЗАХИРГААНЫ УДИРДАХ АЛБАН ТУШААЛТНУУДЫН ТОО, хүйс, жилээр
    ## 478                                                   МОНГОЛ УЛСЫН ТӨРИЙН АЛБАН ХААГЧИД, төрийн албаны ангилал, хүйс, насны бүлэг, аймаг, нийслэл, жилээр, 1995-2022
    ## 479                                                                                     МОНГОЛ УЛСЫН ТӨРИЙН ЗАХИРГААНЫ АЛБАН ХААГЧИД, албан тушаалын ангилал, жилээр
    ## 480                                                                    МОНГОЛ УЛСЫН ТӨРИЙН АЛБАН ХААГЧИД, хүйс, насны бүлэг, аймаг, нийслэл, жилээр, 2023 оноос хойш
    ## 481                                                           МОНГОЛ УЛСЫН ТӨРИЙН АЛБАН ХААГЧИД, төрийн албаны ангилал, хүйс, аймаг нийслэл, жилээр, 2023 оноос хойш
    ## 482                                 1.3.1 НИЙГМИЙН ХАМГААЛЛЫН СУУРЬ ХӨТӨЛБӨРТ ХАМРАГДСАН ХҮН АМЫН НИЙТ ХҮН АМД ЭЗЛЭХ ХУВЬ, хүйс, насны ангилал, байршил, бүс, жилээр
    ## 483                                                             5.5.2 УДИРДАХ АЛБАН ТУШААЛД АЖИЛЛАГЧДАД ЭМЭГТЭЙЧҮҮДИЙН ЭЗЛЭХ ХУВЬ, насны бүлэг, байршил, бүс, жилээр
    ## 484                                                                               8.2.1 ЗЭРЭГЦҮҮЛЭХ ҮНЭЭР ТООЦСОН НЭГ АЖИЛЛАГЧИД НОГДОХ ДНБ-НИЙ ЖИЛИЙН ӨСӨЛТ, жилээр
    ## 485                                                          8.5.1 ЦАЛИНТАЙ АЖИЛЛАГЧДЫН ЦАГИЙН ДУНДАЖ ХӨЛС, ажил мэргэжлийн ангилал, нас, хүйс, байршил, бүс, жилээр
    ## 486                                                                        8.5.2 АЖИЛГҮЙДЛИЙН ТҮВШИН (хувиар), хүйс, насны бүлэг, хөгжлийн бэрхшээлтэй иргэд, жилээр
    ## 487                           8.6.1 ХӨДӨЛМӨР ЭРХЛЭЭГҮЙ БОЛОН БОЛОВСРОЛ, СУРГАЛТАД ХАМРАГДААГҮЙ БАЙГАА 15-24 НАСНЫ ЗАЛУУЧУУДЫН ЭЗЛЭХ ХУВЬ, хүйс, байршил, бүс, жилээр
    ## 488                                                                              8.8.1 АЖЛЫН БАЙР ДАХЬ ХҮНД БОЛОН ХӨНГӨН ОСОЛ ГЭМТЛИЙН ДАВТАМЖИЙН ХУВЬ, хүйс, жилээр
    ## 489                                8.7.1 ХӨДӨЛМӨР ЭРХЭЛЖ БУЙ 5-17 НАСНЫ ХҮҮХДИЙН ТУХАЙН НАСНЫ ХҮҮХДЭД ЭЗЛЭХ ХУВЬ, хүйс, насны бүлэг, байршил, бүс, судалгааны жилээр
    ## 490                                                                                          10.4.1 ДНБ-НД ЦАЛИН, НИЙГМИЙН ХАМГААЛЛЫН ШИЛЖҮҮЛГИЙН ЭЗЛЭХ ХУВЬ, жилээр
    ## 491                                  1.А.2 ТӨСВИЙН НИЙТ ЗАРЛАГАД СУУРЬ ҮЙЛЧИЛГЭЭ (БОЛОВСРОЛ, ЭРҮҮЛ МЭНД, НИЙГМИЙН ХАМГААЛАЛ)-НД ЗОРИУЛСАН ЗАРДЛЫН ЭЗЛЭХ ХУВЬ, жилээр
    ## 492                                                                                            EMPL-1 ХӨДӨЛМӨР ЭРХЛЭЛТИЙН ТҮВШИН, хүйс, насны бүлэг, байршил, жилээр
    ## 493                       EARN-1 ХӨДӨЛМӨР ЭРХЭЛЖ БАЙГАА БОЛОВЧ ЯДУУРЛЫН ШУГАМААС ДООГУУР ХЭРЭГЛЭЭТЭЙ ХҮН АМЫН ХУВИЙН ЖИН, хүйс, насны бүлэг, аймаг, нийслэл,  жилээр
    ## 494                                                                                   EARN-2 БАГА ЦАЛИНТАЙ АЖИЛЛАГЧДЫН ХУВЬ, хүйс, насны бүлэг, байршил, бүс, жилээр
    ## 495                                                         TIME-1 ХЭТ ОЛОН ЦАГААР АЖИЛЛАГЧИД (долоо хоногт 48 цагаас илүү), хүйс, насны бүлэг, байршил, бүс, жилээр
    ## 496                                                                              EQUA-1 АЖИЛ МЭРГЭЖИЛ ДЭХ ЖЕНДЭРИЙН ЗӨРҮҮТЭЙ БАЙДАЛ, ажил мэргэжлийн ангилал, жилээр
    ## 497                                                                                                  SECU-1 ӨНДӨР НАСНЫ ТЭТГЭВЭР АВЧ БУЙ ХҮН АМЫН ЭЗЛЭХ ХУВЬ, жилээр
    ## 498                                                                                                                     DIAL-1 Үйлдвэрчний эвлэлийн нягтралын түвшин
    ## 499                                                                                             CONT-1 СУРГУУЛЬД ХАМРАГДААГҮЙ ХҮҮХДИЙН ЭЗЛЭХ ХУВЬ, хүйс, бүс, жилээр
    ## 500                                                                             CONT-2 ХӨДӨЛМӨР ЭРХЛЭХ НАСНЫ ХҮН АМД ХДХВ-ИЙН ХАЛДВАРТАЙ ХҮН АМЫН ЭЗЛЭХ ХУВЬ, жилээр
    ## 501                                                                                  CONT-4 ОРЛОГЫН ТЭГШ БУС БАЙДАЛ (90:10 ХАРЬЦАА), нас, хүйс, байршил, бүс, жилээр
    ## 502                                                                                                  CONT-5 ИНФЛЯЦИЙН ТҮВШИН (ХЭРЭГЛЭЭНИЙ ҮНИЙН ИНДЕКС), бүс, жилээр
    ## 503                                                                                               CONT-6 АЖИЛЛАГЧИД, эдийн засгийн үйл ажиллагааны салбараар, жилээр
    ## 504                                                                             CONT-7 НАСАНД ХҮРЭГЧДИЙН БИЧИГ ҮСЭГ ТАЙЛАГДАЛТЫН ХУВЬ, хүйс, тооллого явагдсан оноор
    ## 505                                                                            БҮРТГЭЛТЭЙ АЖИЛГҮЙ ИРГЭД, насны бүлэг, хүйс, аймаг, нийслэл, сараар /2008.01-2024.04/
    ## 506                                                                     БҮРТГЭЛТЭЙ АЖИЛГҮЙ ИРГЭД, боловсролын түвшин, хүйс, аймаг, нийслэл, сараар /2008.01-2024.04/
    ## 507                                                                                        БҮРТГЭЛТЭЙ АЖИЛГҮЙ ИРГЭДИЙН ХӨДӨЛГӨӨН, аймаг, нийслэл, сараар /2014-2021/
    ## 508                                                                                    АЖИЛ ХАЙГЧ ИРГЭД, насны бүлэг, хүйс, аймаг, нийслэл, сараар /2014.01-2024.04/
    ## 509                                                                             АЖИЛ ХАЙГЧ ИРГЭД, боловсролын түвшин, хүйс, аймаг, нийслэл, сараар /2014.01-2024.04/
    ## 510                                                                                                     АЛБАН БУС ХӨДӨЛМӨР ЭРХЛЭЛТ, хүйс,бүс, аймаг, нийслэл, жилээр
    ## 511                                                                         АЛБАН БУС ХӨДӨЛМӨР ЭРХЛЭГЧИД, үйл ажиллагааны нэгжээр, бүс, аймаг, нийслэл, хүйс, жилээр
    ## 512                                                АЛБАН БУС ХӨДӨЛМӨР ЭРХЛЭГЧИД, эдийн засгийн үйл ажиллагааны салбарын ангиллаар, бүс, аймаг, нийслэл, хүйс, жилээр
    ## 513                                                                   АЛБАН БУС ХӨДӨЛМӨР ЭРХЛЭГЧИД, хөдөлмөр эрхлэлтийн статусаар, бүс, аймаг, нийслэл, хүйс, жилээр
    ## 514                                                                                         ХӨДӨЛМӨРИЙН ГЭРЭЭГЭЭР АЖИЛ ЭРХЭЛЖ БУЙ ГАДААДЫН ИРГЭД, улс орон, улирлаар
    ## 515                                                                             ХӨДӨЛМӨРИЙН ГЭРЭЭГЭЭР АЖИЛ ЭРХЭЛЖ БУЙ ГАДААДЫН ИРГЭД, эдийн засгийн салбар, улирлаар
    ## 516                                                                                   ХӨДӨЛМӨРИЙН ГЭРЭЭГЭЭР АЖИЛ ЭРХЭЛЖ БУЙ ГАДААДЫН ИРГЭД, аймаг, нийслэл, улирлаар
    ## 517                                                                                                            ХӨДӨЛМӨРИЙН СОНИРХЛЫН МАРГААН, аймаг, нийслэл, жилээр
    ## 518                                                                             ХӨДӨЛМӨРИЙН ГЭРЭЭГЭЭР ГАДААД УЛСАД ЗУУЧЛАГДСАН ИРГЭД, эдийн засгийн салбар, улирлаар
    ## 519                                                                        ЖИЖИГ, ДУНД ҮЙЛДВЭР, ҮЙЛЧИЛГЭЭ ЭРХЛЭГЧДИЙН НИЙТ ЭКСПОРТ, ИМПОРТЫН ДҮНД ЭЗЛЭХ ХУВЬ, жилээр
    ## 520                                                       ДНБ-Д ЖИЖИГ, ДУНД ҮЙЛДВЭР, ҮЙЛЧИЛГЭЭ ЭРХЛЭГЧДИЙН НЭМЭГДЭЛ ӨРТГИЙН ЭЗЛЭХ ХУВЬ, эдийн засгийн салбар, жилээр
    ## 521                                                             ДНБ-Д ЖИЖИГ, ДУНД ҮЙЛДВЭР, ҮЙЛЧИЛГЭЭ ЭРХЛЭГЧДИЙН НЭМЭГДЭЛ ӨРТГИЙН ЭЗЛЭХ ХУВЬ, аймаг, нийслэл, жилээр
    ## 522                                                                                    ЖИЖИГ, ДУНД ҮЙЛДВЭР, ҮЙЛЧИЛГЭЭ ЭРХЛЭГЧ ХУУЛИЙН ЭТГЭЭД, аймаг, нийслэл, жилээр
    ## 523                                                                              ЖИЖИГ, ДУНД ҮЙЛДВЭР, ҮЙЛЧИЛГЭЭ ЭРХЛЭГЧ ХУУЛИЙН ЭТГЭЭД, эдийн засгийн салбар, жилээр
    ## 524                                               ЖИЖИГ, ДУНД ҮЙЛДВЭР, ҮЙЛЧИЛГЭЭ ЭРХЛЭГЧ ХУУЛИЙН ЭТГЭЭД, ажиллагчдын тооны бүлэг, борлуулалтын орлогын бүлэг, жилээр
    ## 525                                                                                            БИЗНЕС РЕГИСТРИЙН САНД БҮРТГЭЛТЭЙ ХОРШОО, ГИШҮҮД, сум, дүүрэг, жилээр
    ## 526                                                                 БИЗНЕС РЕГИСТРИЙН САНД БҮРТГЭЛТЭЙ ХОРШООНЫ ХУВЬ НИЙЛҮҮЛСЭН ХӨРӨНГИЙН ХЭМЖЭЭ, сум, дүүрэг, жилээр
    ## 527                                             БИЗНЕС РЕГИСТРИЙН САНД БҮРТГЭЛТЭЙ ХУУЛИЙН ЭТГЭЭДИЙН ТОО, үйл ажиллагаа эрхлэлтийн байдал, хариуцлагын хэлбэр, жилээр
    ## 528                                                                          ҮЙЛ АЖИЛЛАГАА ЯВУУЛЖ БАЙГАА ХУУЛИЙН ЭТГЭЭДИЙН ТОО, өмчийн хэлбэр, сум, дүүрэг, улирлаар
    ## 529                                                              ҮЙЛ АЖИЛЛАГАА ЯВУУЛЖ БАЙГАА ХУУЛИЙН ЭТГЭЭДИЙН ТОО, өмчийн хэлбэр, ажиллагчдын тооны бүлэг, улирлаар
    ## 530                                                         ҮЙЛ АЖИЛЛАГАА ЯВУУЛЖ БАЙГАА ХУУЛИЙН ЭТГЭЭДИЙН ТОО, хариуцлагын хэлбэр, ажиллагчдын тооны бүлэг, улирлаар
    ## 531                                                                ҮЙЛ АЖИЛЛАГАА ЯВУУЛЖ БАЙГАА ХУУЛИЙН ЭТГЭЭДИЙН ТОО, ажиллагчдын тооны бүлэг, сум, дүүрэг, улирлаар
    ## 532                                                  БИЗНЕС РЕГИСТРИЙН САНД БҮРТГЭЛТЭЙ ХУУЛИЙН ЭТГЭЭДИЙН ТОО, үйл ажиллагаа эрхлэлтийн байдал, сум, дүүрэг, улирлаар
    ## 533                                                  БИЗНЕС РЕГИСТРИЙН САНД БҮРТГЭЛТЭЙ ХУУЛИЙН ЭТГЭЭДИЙН ТОО, өмчийн хэлбэр, үйл ажиллагаа эрхлэлтийн байдал, жилээр
    ## 534                                                                     ҮЙЛ АЖИЛЛАГАА ЯВУУЛЖ БАЙГАА ХУУЛИЙН ЭТГЭЭДИЙН ТОО, хариуцлагын хэлбэр, сум, дүүрэг, улирлаар
    ## 535                                            ҮЙЛ АЖИЛЛАГАА ЯВУУЛЖ БАЙГАА ХУУЛИЙН ЭТГЭЭДИЙН ТОО, эдийн засгийн үйл ажиллагааны салбар, хариуцлагын хэлбэр, улирлаар
    ## 536                                                                 ҮЙЛ АЖИЛЛАГАА ЯВУУЛЖ БАЙГАА ХУУЛИЙН ЭТГЭЭДИЙН ТОО, эдийн засгийн салбар, өмчийн хэлбэр, улирлаар
    ## 537                                                       ҮЙЛ АЖИЛЛАГАА ЯВУУЛЖ БАЙГАА ХУУЛИЙН ЭТГЭЭДИЙН ТОО, эдийн засгийн салбар, ажиллагчдын тооны бүлэг, улирлаар
    ## 538                                                                             БИЗНЕС РЕГИСТРИЙН САНД БҮРТГЭЛТЭЙ ХОРШООНЫ ТОО, ГИШҮҮД, эдийн засгийн салбар, жилээр
    ## 539                                                        БИЗНЕС РЕГИСТРИЙН САНД БҮРТГЭЛТЭЙ ХОРШООНЫ ХУВЬ НИЙЛҮҮЛСЭН ХӨРӨНГИЙН ХЭМЖЭЭ, эдийн засгийн салбар, жилээр
    ## 540                                                        ҮЙЛ АЖИЛЛАГАА ЯВУУЛЖ БАЙГАА ХУУЛИЙН ЭТГЭЭДИЙН ТОО, эдийн засгийн дэд салбар, хариуцлагын хэлбэр, улирлаар
    ## 541                                                             ҮЙЛ АЖИЛЛАГАА ЯВУУЛЖ БАЙГАА ХУУЛИЙН ЭТГЭЭДИЙН ТОО, эдийн засгийн дэд салбар, өмчийн хэлбэр, улирлаар
    ## 542                                     БИЗНЕС РЕГИСТРИЙН САНД БҮРТГЭЛТЭЙ ХУУЛИЙН ЭТГЭЭДИЙН ТОО, эдийн засгийн дэд салбар, үйл ажиллагаа эрхлэлтийн байдал, улирлаар
    ## 543                                                   ҮЙЛ АЖИЛЛАГАА ЯВУУЛЖ БАЙГАА ХУУЛИЙН ЭТГЭЭДИЙН ТОО, эдийн засгийн дэд салбар, ажиллагчдын тооны бүлэг, улирлаар
    ## 544                                                                        БИЗНЕС РЕГИСТРИЙН САНД БҮРТГЭЛТЭЙ ХОРШОО, ГИШҮҮДИЙН ТОО, эдийн засгийн дэд салбар, жилээр
    ## 545                                                    БИЗНЕС РЕГИСТРИЙН САНД БҮРТГЭЛТЭЙ ХОРШООНЫ ХУВЬ НИЙЛҮҮЛСЭН ХӨРӨНГИЙН ХЭМЖЭЭ, эдийн засгийн дэд салбар, жилээр
    ## 546                                                    ҮЙЛ АЖИЛЛАГАА ЯВУУЛЖ БАЙГАА ХУУЛИЙН ЭТГЭЭДИЙН ТОО, эдийн засгийн салбарын бүлэг, хариуцлагын хэлбэр, улирлаар
    ## 547                                                         ҮЙЛ АЖИЛЛАГАА ЯВУУЛЖ БАЙГАА ХУУЛИЙН ЭТГЭЭДИЙН ТОО, эдийн засгийн салбарын бүлэг, өмчийн хэлбэр, улирлаар
    ## 548                                 БИЗНЕС РЕГИСТРИЙН САНД БҮРТГЭЛТЭЙ ХУУЛИЙН ЭТГЭЭДИЙН ТОО, эдийн засгийн салбарын бүлэг, үйл ажиллагаа эрхлэлтийн байдал, улирлаар
    ## 549                                               ҮЙЛ АЖИЛЛАГАА ЯВУУЛЖ БАЙГАА ХУУЛИЙН ЭТГЭЭДИЙН ТОО, эдийн засгийн салбарын бүлэг, ажиллагчдын тооны бүлэг, улирлаар
    ## 550                                                                   ҮЙЛ АЖИЛЛАГАА ЯВУУЛЖ БАЙГАА ХУУЛИЙН ЭТГЭЭДИЙН ТОО, эдийн засгийн салбар, сум, дүүрэг, улирлаар
    ## 551                                         БИЗНЕС РЕГИСТРИЙН САНД БҮРТГЭЛТЭЙ ХУУЛИЙН ЭТГЭЭДИЙН ТОО, эдийн засгийн салбар, үйл ажиллагаа эрхлэлтийн байдал, улирлаар
    ## 552                                                                                                    МОНГОЛ УЛСАД ОРШИН СУУГАА ХҮН АМЫН ТОО, хүйс, нэг нас, жилээр
    ## 553                                                                                                                              ХҮН АМЫН ТОО, хүйс, нэг нас, жилээр
    ## 554                                                                                                               ЖИЛИЙН ДУНДАЖ ХҮН АМЫН ТОО, аймаг, нийслэл, жилээр
    ## 555                                                                                         МОНГОЛ УЛСАД ОРШИН СУУГАА ЖИЛИЙН ДУНДАЖ ХҮН АМЫН ТОО, баг, хороо, жилээр
    ## 556                                                                                                                          ХҮН АМЫН ТОО, хүйс, насны бүлэг, жилээр
    ## 557                                                                                                                    ХҮН АМЫН ТОО, байршил, аймаг, нийслэл, жилээр
    ## 558                                                                                              МОНГОЛ УЛСАД ОРШИН СУУГАА ХҮН АМЫН ТОО, байршил, баг, хороо, жилээр
    ## 559                                                                                                                      ӨРХИЙН ТОО, байршил, аймаг, нийслэл, жилээр
    ## 560                                                                                                                                  ӨРХИЙН ТОО, сум, дүүрэг, жилээр
    ## 561                                                                                                                          ӨРХИЙН ТОО, байршил, баг, хороо, жилээр
    ## 562                                                                                                                 БҮТЭН ӨНЧИН ХҮҮХДИЙН ТОО, аймаг, нийслэл, жилээр
    ## 563                                                                                     ЭЦЭГ, ЭХИЙН ХЭН НЭГЭНТЭЙ АМЬДАРЧ БАЙГАА ХҮҮХДИЙН ТОО, аймаг, нийслэл, жилээр
    ## 564                                                                                           ӨРХ ТОЛГОЙЛСОН ЭХИЙН ТОО, өрхийн гишүүдийн тоо, аймаг, нийслэл, жилээр
    ## 565                                                                                           18 ХҮРТЭЛХ НАСНЫ 4, ТҮҮНЭЭС ДЭЭШ ХҮҮХЭДТЭЙ ӨРХ, аймаг, нийслэл, жилээр
    ## 566                                                                             ӨРХ ҮҮСГЭН ГАНЦ БИЕЭР АМЬДАРДАГ ӨНДӨР НАСТАЙ ХҮНИЙ ТОО, хүйс, аймаг, нийслэл, жилээр
    ## 567                                                                                                                              ХҮН АМЫН ТОО, байршил, хүйс, жилээр
    ## 568                                                                                                                               ӨРХИЙН ТОО, аймаг, нийслэл, жилээр
    ## 569                                                                                                                         ХҮН АМЫН НЯГТРАЛ, аймаг, нийслэл, жилээр
    ## 570                                                                                                                            ХҮН АМЫН НЯГТРАЛ, сум, дүүрэг, жилээр
    ## 571                                                                                                                      ХҮН АМ ЗҮЙН АЧААЛАЛ, аймаг, нийслэл, жилээр
    ## 572                                                                                                                         ХҮН АМ ЗҮЙН АЧААЛАЛ, сум, дүүрэг, жилээр
    ## 573                                                                                                                ХҮН АМЫН ШИЛЖИХ ХӨДӨЛГӨӨН, аймаг, нийслэл, жилээр
    ## 574                                                                                          МОНГОЛ УЛСАД ОРШИН СУУГАА ХҮН АМЫН ТОО, насны бүлэг, баг, хороо, жилээр
    ## 575                                                                                                 МОНГОЛ УЛСАД ОРШИН СУУГАА ХҮН АМЫН ТОО, хүйс, баг, хороо, жилээр
    ## 576                                                      15 БА ТҮҮНЭЭС ДЭЭШ НАСНЫ СУУРИН ХҮН АМЫН ТОО, насны бүлэг, хүйс, гэрлэлтийн байдал, тооллого явагдсан оноор
    ## 577                                                                                                         ӨРХ ТОЛГОЙЛСОН ГАНЦ БИЕ ЭЦЭГ, ЭХ, аймаг, нийслэл, жилээр
    ## 578                                                                                             18 ХҮРТЭЛХ НАСНЫ ХҮҮХЭДТЭЙ ӨРХ ТОЛГОЙЛСОН ЭХ, аймаг, нийслэл, жилээр
    ## 579                                                                                       1000 ХҮНД НОГДОХ ТӨРӨЛТ, НАС БАРАЛТ, ЦЭВЭР ӨСӨЛТ, аймаг, нийслэл, улирлаар
    ## 580                                                                                                                                      ТӨРӨЛТИЙН ТОО, хүйс, жилээр
    ## 581                                                                                                                               НАС БАРСАН ХҮНИЙ ТОО, хүйс, жилээр
    ## 582                                                                                                                      ТӨРӨЛТИЙН ТОО, хүйс, аймаг, нийслэл, жилээр
    ## 583                                                                                                                  НАС БАРСАН ХҮНИЙ ТОО, хүйс, сум, дүүрэг, жилээр
    ## 584                                                                                                               НАС БАРСАН ХҮНИЙ ТОО, хүйс, аймаг, нийслэл, жилээр
    ## 585                                                                                                                      ТӨРӨЛТИЙН ТОО, хүйсээр, сум, дүүрэг, жилээр
    ## 586                                                                                                                 НАС БАРСАН ХҮНИЙ ТОО, боловсролын түвшин, жилээр
    ## 587                                                                                                                  НАС БАРСАН ХҮНИЙ ТОО, хүйс, насны бүлэг, жилээр
    ## 588                                                                                                        НАС БАРСАН ХҮНИЙ ТОО, насны бүлэг, аймаг, нийслэл, жилээр
    ## 589                                                                                                           НАС БАРСАН ХҮНИЙ ТОО, насны бүлэг, сум, дүүрэг, жилээр
    ## 590                                                                                                                   ГЭРЛЭЛТ, ЦУЦЛАЛТЫН ТОО, аймаг, нийслэл, жилээр
    ## 591                                                                                                                       ГЭРЛЭЛ, ЦУЦЛАЛТЫН ТОО, сум, дүүрэг, жилээр
    ## 592                                                                                                       ГЭРЛЭЛТЭЭ БҮРТГҮҮЛСЭН ХҮНИЙ ТОО, хүйс, насны бүлэг, жилээр
    ## 593                                                                                                ГЭРЛЭЛТЭЭ БҮРТГҮҮЛСЭН ХҮНИЙ ТОО, насны бүлэг, сум, дүүрэг, жилээр
    ## 594                                                                                                       ГЭРЛЭЛТ, ЦУЦЛАЛТ, 1000 хүнд ногдох, аймаг, нийслэл, жилээр
    ## 595                                                                                                          ГЭРЛЭЛТ, ЦУЦЛАЛТ, 1000 хүнд ногдох, сум, дүүрэг, жилээр
    ## 596                                                                                                            ГЭР БҮЛ ЦУЦЛАЛТЫН ТОО, гэр бүл байсан хугацаа, жилээр
    ## 597                                                                                                                     ҮРЧЛҮҮЛСЭН ХҮҮХДИЙН ТОО, насны бүлэг, жилээр
    ## 598                                                                                                                   ТӨРСӨН ХҮҮХДИЙН ТОО, эхийн насны бүлэг, жилээр
    ## 599                                                                                                   ТӨРСӨН ХҮҮХДИЙН ТОО, эхийн насны бүлэг, аймаг, нийслэл, жилээр
    ## 600                                                                                                    ТӨРСӨН ХҮҮХДИЙН ТОО, эхийн насны бүлгээр, сум, дүүрэг, жилээр
    ## 601                                                                                 ТӨРӨЛТ, НАС БАРАЛТ, ЕРДИЙН ЦЭВЭР ӨСӨЛТ, 1000 хүнд ногдох, аймаг, нийслэл, жилээр
    ## 602                                                                                                      НАС БАРАЛТЫН ЕРӨНХИЙ КОЭФФИЦИЕНТ, хүйс, сум, дүүрэг, жилээр
    ## 603                                                                                                                                    ТӨРӨЛТИЙН КОЭФФИЦИЕНТ, жилээр
    ## 604                                                                                                               ТӨРӨЛТИЙН ЕРӨНХИЙ КОЭФФИЦИЕНТ, сум, дүүрэг, жилээр
    ## 605                                                                                                            ХҮН АМЫН ДУНДАЖ НАСЛАЛТ, хүйс, аймаг, нийслэл, жилээр
    ## 606                                                                                                              ТӨРӨХ ҮЕИЙН ХҮЙСИЙН ХАРЬЦАА, аймаг, нийслэл, жилээр
    ## 607                                                                                                                 ТӨРӨХ ҮЕИЙН ХҮЙСИЙН ХАРЬЦАА, сум, дүүрэг, жилээр
    ## 608                                                                                                                            ТӨРӨЛТИЙН ТОО, аймаг, нийслэл, жилээр
    ## 609                                                                                                                     НАС БАРСАН ХҮНИЙ ТОО, аймаг, нийслэл, жилээр
    ## 610                                                                                                           ХҮҮХЭД ТӨРҮҮЛСЭН ЭХЧҮҮДИЙН ТОО, аймаг, нийслэл, жилээр
    ## 611                                                                                                       ХҮҮХЭД ТӨРҮҮЛСЭН ЭХЧҮҮДИЙН ТОО, боловсролын түвшин, жилээр
    ## 612                                                                                       ХҮҮХЭД ТӨРҮҮЛСЭН ЭХЧҮҮДИЙН ТОО, боловсролын түвшин, аймаг, нийслэл, жилээр
    ## 613                                                                                          ХҮҮХЭД ТӨРҮҮЛСЭН ЭХЧҮҮДИЙН ТОО, боловсролын түвшин, сум, дүүрэг, жилээр
    ## 614                                                                                                                                     ДУНДАЖ НАСЛАЛТ, хүйс, жилээр
    ## 615                                                                                        ХҮҮХЭД ТӨРҮҮЛСЭН ЭХЧҮҮДИЙН ТОО, гэрлэлтийн байдал, аймаг, нийслэл, жилээр
    ## 616                                                                                          ХҮҮХЭД ТӨРҮҮЛСЭН ЭХЧҮҮДИЙН ТОО, гэрлэлтийн байдал , сум, дүүрэг, жилээр
    ## 617                                                                                                                ҮРЧЛЭЛТ, 1000 хүнд ногдох, аймаг, нийслэл, жилээр
    ## 618                                                                                                                                     ҮРЧЛЭЛТ, сум, дүүрэг, жилээр
    ## 619                                                                                                                                  МАЛЧДЫН ТОО, баг, хороо, жилээр
    ## 620                                                                                                                            МАЛТАЙ ӨРХИЙН ТОО, баг, хороо, жилээр
    ## 621                                                                                                                            МАЛЧИН ӨРХИЙН ТОО, баг, хороо, жилээр
    ## 622                                                                                                              МАЛЧИН ӨРХИЙН ЗАРИМ ҮЗҮҮЛЭЛТҮҮД, баг, хороо, жилээр
    ## 623                                                                                                        МАЛЫН ТООНЫ БҮЛЭГЛЭЛТ, малтай өрх, аймаг, нийслэл, жилээр
    ## 624                                                                                                  ХУДАГ, УСАН САН, УСТ ЦЭГИЙН ТОО, төрөл, баг, хороо, 3 жил тутам
    ## 625                                                         ХҮН БАЙНГА АМЬДАРДАГ БАЙШИНГИЙН ТОО, ханын үндсэн материал, бүс, аймаг, нийслэл, тооллого явагдсан оноор
    ## 626                                                                                                        ХАЛУУН УСНЫ ҮЙЛЧИЛГЭЭ, бүс, аймаг, нийслэлээр /1994-2019/
    ## 627                                                                      ӨРХИЙН ТОО, цахилгааны эх үүсвэр, бүс, аймаг, нийслэл, сум, дүүрэг, тооллого явагдсан оноор
    ## 628                                                                 ӨРХИЙН ТОО, усан хангамжийн эх үүсвэр, бүс, аймаг, нийслэл, сум, дүүрэг, тооллого явагдсан оноор
    ## 629                                                                                            БАЙШИН СУУЦНЫ ТОО, сууцны төрөл, өрөөний тоо, тооллого явагдсан оноор
    ## 630  ЦЭВЭРЛЭХ БАЙГУУЛАМЖ, АРИУТГАХ ТАТУУРГЫН ШУГАМ СҮЛЖЭЭНД ХОЛБОГДСОН БОЛОН ХОЛБОГДООГҮЙ НИЙТ ӨРХИЙН ТОО, бүс, аймаг, нийслэл, сум, дүүрэг, тооллого явагдсан оноор
    ## 631                                                                                СУУЦНЫ ТОО, сууцны төрөл, шалны үндсэн материалын төрөл, тооллого явагдсан жилээр
    ## 632                     ТӨВЛӨРСӨН БОЛОН БИЕ ДААСАН ИНЖЕНЕРИЙН БҮРЭН ХАНГАМЖТАЙ ОРОН СУУЦАНД АМЬДАРДАГ ӨРХ, бүс, аймаг, нийслэл, сум, дүүрэг, тооллого явагдсан оноор
    ## 633                                           БАЙШИН, ГЭР БОЛОН БУСАД СУУЦАНД АМЬДАРДАГ ӨРХ, сууцны төрөл, бүс, аймаг, нийслэл, сум, дүүрэг, тооллого явагдсан оноор
    ## 634                  МОНГОЛ УЛСЫН НУТАГ ДЭВСГЭРТ ОРШИН СУУГАА ХҮН АМЫН ХУВЬД ТООЦСОН ХҮН АМЫН ТОО, хүйс, насны бүлэг, аймаг, нийслэл, дунд хувилбар 1Б, 2020-2050 он
    ## 635                                  МОНГОЛ УЛСЫН НУТАГ ДЭВСГЭРТ ОРШИН СУУГАА ХҮН АМЫН ХУВЬД ТООЦСОН ХҮН АМЫН ТОО, хүйс, насны бүлэг, дунд хувилбар 1Б, 2020-2050 он
    ## 636                                                      МОНГОЛ УЛСЫН ХАРЬЯАТ ХҮН АМЫН ХУВЬД ТООЦСОН ХҮН АМЫН ТОО, хүйс, насны бүлэг, дунд хувилбар 2Б, 2020-2050 он
    ## 637                                                                                  МОНГОЛ УЛСЫН ЗАСАГ ЗАХИРГАА, НУТАГ ДЭВСГЭРИЙН НЭГЖ, бүс, аймаг, нийслэл, жилээр
    ## 638                                                                                                                                            ТОМООХОН УУЛС, жилээр
    ## 639                                                                                                                                             ТОМООХОН ГОЛ, жилээр
    ## 640                                                                                                                                            ТОМООХОН НУУР, жилээр
    ## 641                                                                                                            ТАРИАЛСАН ТАЛБАЙ, ургамлын төрөл, сум, дүүрэг, жилээр
    ## 642                                                                                                              ХУРААСАН УРГАЦ, ургамлын төрөл, сум, дүүрэг, жилээр
    ## 643                                                                                                             ТАРИАЛАН ЭРХЭЛДЭГ ӨРХИЙН ТОО, аймаг, нийслэл, жилээр
    ## 644                                                                                        ТАРИАЛАН ЭРХЭЛДЭГ АЖ АХУЙН НЭГЖ, БАЙГУУЛЛАГЫН ТОО, аймаг, нийслэл, жилээр
    ## 645                                                                          БАРИЛГА УГСРАЛТ, ИХ ЗАСВАРЫН АЖИЛ, барилгын төрөл, аймаг, нийслэл, улирлаар (өссөн дүн)
    ## 646                                                            ДОТООДЫН БАРИЛГЫН БАЙГУУЛЛАГЫН ГҮЙЦЭТГЭСЭН БАРИЛГА УГСРАЛТ, ИХ ЗАСВАРЫН АЖИЛ, сум, дүүргээр, улирлаар
    ## 647                                                                                          АШИГЛАЛТАД ОРУУЛСАН ҮНДСЭН ФОНД, барилгын төрөл, аймаг, нийслэл, жилээр
    ## 648                                                                          БАРИЛГА УГСРАЛТ, ИХ ЗАСВАРЫН АЖИЛ, барилгын төрөл, аймаг, нийслэл, улирлаар (өссөн дүн)
    ## 649                                                                                                     ХӨГЖЛИЙН БЭРХШЭЭЛТЭЙ ХҮНИЙ ТОО, хүйс, аймаг, нийслэл, жилээр
    ## 650                                                                                                   ХАРААНЫ ХӨГЖЛИЙН БЭРХШЭЭЛТЭЙ ХҮН, хүйс, аймаг, нийслэл, жилээр
    ## 651                                                                                           СОНСГОЛЫН ХӨГЖЛИЙН БЭРХШЭЭЛТЭЙ ХҮНИЙ ТОО, хүйс, аймаг, нийслэл, жилээр
    ## 652                                                                                          ХЭЛ ЯРИАНЫ ХӨГЖЛИЙН БЭРХШЭЭЛТЭЙ ХҮНИЙ ТОО, хүйс, аймаг, нийслэл, жилээр
    ## 653                                                                                         ХӨДӨЛГӨӨНИЙ ХӨГЖЛИЙН БЭРХШЭЭЛТЭЙ ХҮНИЙ ТОО, хүйс, аймаг, нийслэл, жилээр
    ## 654                                                                                           СЭТГЭЦИЙН ХӨГЖЛИЙН БЭРХШЭЭЛТЭЙ ХҮНИЙ ТОО, хүйс, аймаг, нийслэл, жилээр
    ## 655                                                                                 ХАВСАРСАН ХЭЛБЭРИЙН ХӨГЖЛИЙН БЭРХШЭЭЛТЭЙ ХҮНИЙ ТОО, хүйс, аймаг, нийслэл, жилээр
    ## 656                                                                                       БУСАД ТӨРЛИЙН ХӨГЖЛИЙН БЭРХШЭЭЛТЭЙ ХҮНИЙ ТОО, хүйс, аймаг, нийслэл, жилээр
    ## 657                                                                                               ЕРӨНХИЙ БОЛОВСРОЛЫН СУРГУУЛИЙН ҮНДСЭН БАГШ, аймаг, нийслэл, жилээр
    ## 658                                                                                                  ЕРӨНХИЙ БОЛОВСРОЛЫН СУРГУУЛИЙН ҮНДСЭН БАГШ, сум, дүүрэг, жилээр
    ## 659                                                                                    ЕРӨНХИЙ БОЛОВСРОЛЫН СУРГУУЛЬД ӨДРӨӨР СУРАЛЦАГЧДЫН ТОО, аймаг, нийслэл, жилээр
    ## 660                                                                                                          ЕРӨНХИЙ БОЛОВСРОЛЫН СУРГУУЛИЙН ТОО, сум, дүүрэг, жилээр
    ## 661                                                                                    ЕРӨНХИЙ БОЛОВСРОЛЫН СУРГУУЛЬД ӨДРӨӨР СУРАЛЦАГЧДЫН ТОО, аймаг, нийслэл, жилээр
    ## 662                                                          ТЕХНИКИЙН БОЛОН МЭРГЭЖЛИЙН БОЛОВСРОЛЫН СУРГАЛТЫН БАЙГУУЛЛАГАД СУРАЛЦАГЧИД, хүйс, аймаг, нийслэл, жилээр
    ## 663                                               ТЕХНИКИЙН БОЛОН МЭРГЭЖЛИЙН БОЛОВСРОЛЫН СУРГАЛТЫН БАЙГУУЛЛАГЫН АЖИЛЛАГЧИД БОЛОН ҮНДСЭН БАГШ, аймаг, нийслэл, жилээр
    ## 664                                                                             СУРГУУЛИЙН ӨМНӨХ БОЛОВСРОЛЫН БАЙГУУЛЛАГЫН ҮНДСЭН БАГШИЙН ТОО, аймаг, нийслэл, жилээр
    ## 665                                                                               СУРГУУЛИЙН ӨМНӨХ БОЛОВСРОЛЫН БАЙГУУЛЛАГЫН АЖИЛЛАГЧИД, хүйс, аймаг, нийслэл, жилээр
    ## 666                                                                                                                          ЦЭЦЭРЛЭГИЙН ТОО, аймаг, нийслэл, жилээр
    ## 667                                                                                                                             ЦЭЦЭРЛЭГИЙН ТОО, сум, дүүрэг, жилээр
    ## 668                                                                        СУРГУУЛИЙН ӨМНӨХ БОЛОВСРОЛЫН БАЙГУУЛЛАГАД ХАМРАГДСАН ХҮҮХДИЙН ТОО, аймаг, нийслэл, жилээр
    ## 669                                                                                            ИХ, ДЭЭД СУРГУУЛЬ, КОЛЛЕЖИД СУРАЛЦАГЧИД, хүйс, аймаг, нийслэл, жилээр
    ## 670                                                  ЕРӨНХИЙ БОЛОВСРОЛЫН СУРГУУЛИЙН СУРАЛЦАГЧДААС ДОТУУР БАЙРАНД СУУХ ХҮСЭЛТ ГАРГАСАН ХҮҮХЭД, аймаг, нийслэл, жилээр
    ## 671                                                           ЕРӨНХИЙ БОЛОВСРОЛЫН СУРГУУЛИЙН СУРАЛЦАГЧДААС ДОТУУР БАЙРАНД АМЬДАРЧ БУЙ ХҮҮХЭД, аймаг, нийслэл, жилээр
    ## 672                                                 ТЕХНИКИЙН БОЛОН МЭРГЭЖЛИЙН БОЛОВСРОЛ, СУРГАЛТЫН БАЙГУУЛЛАГЫГ ТӨГСӨГЧИД, сургалтын чиглэл, аймаг, нийслэл, жилээр
    ## 673                                                                                               ЕБС-ИЙН НЭГДҮГЭЭР АНГИД ШИНЭЭР ЭЛСЭГЧДИЙН ТОО, сум, дүүрэг, жилээр
    ## 674                                                                                               СУРГУУЛИЙН ӨМНӨХ БАЙГУУЛЛАГЫН АЖИЛЛАГЧДЫН ТОО, сум, дүүрэг, жилээр
    ## 675                                                                                    ЭЛСЭЛТИЙН ЕРӨНХИЙ ШАЛГАЛТЫН ДҮН (ХЭМЖЭЭСТ ОНОО), хүйс, аймаг, нийслэл, жилээр
    ## 676                                                                           ЕРӨНХИЙ БОЛОВСРОЛЫН СУРГУУЛИЙГ ӨДРӨӨР СУРАЛЦАН ТӨГСӨГЧИД, анги, аймаг, нийслэл, жилээр
    ## 677                                                                                       ЕРӨНХИЙ БОЛОВСРОЛЫН СУРГУУЛЬД ӨДРӨӨР СУРАЛЦАГЧДЫН ТОО, сум, дүүрэг, жилээр
    ## 678                                                                                    ЕРӨНХИЙ БОЛОВСРОЛЫН СУРГУУЛИЙГ ӨДРӨӨР СУРАЛЦАН ТӨГСӨГЧИД, сум, дүүрэг, жилээр
    ## 679                                                                 ЕРӨНХИЙ БОЛОВСРОЛЫН СУРГУУЛЬД СУРАЛЦДАГ ХӨГЖЛИЙН БЭРХШЭЭЛТЭЙ СУРАЛЦАГЧИД, аймаг, нийслэл, жилээр
    ## 680                                                   СУРГУУЛИЙН ӨМНӨХ БОЛОВСРОЛЫН БАЙГУУЛЛАГАД ХАМРАГДСАН ХӨГЖЛИЙН БЭРХШЭЭЛТЭЙ ХҮҮХЭД, хүйс, аймаг, нийслэл, жилээр
    ## 681                                                                                               СУРГУУЛИЙН ӨМНӨХ БОЛОВСРОЛД ХАМРАГДСАН ХҮҮХЭД, сум, дүүрэг, жилээр
    ## 682                                                                             ИРГЭДИЙН ТӨЛӨӨЛӨГЧДИЙН ХУРЛЫН ТӨЛӨӨЛӨГЧИД, хүйс, насны бүлэг, аймаг, нийслэл, жилээр
    ## 683                                                                                ИРГЭДИЙН ТӨЛӨӨЛӨГЧДИЙН ХУРЛЫН ТӨЛӨӨЛӨГЧИД, хүйс, насны бүлэг, сум, дүүрэг, жилээр
    ## 684                                                                 ИРГЭДИЙН ТӨЛӨӨЛӨГЧДИЙН ХУРЛЫН ТӨЛӨӨЛӨГЧИД, хүйс, насны бүлэг, аймаг, нийслэл, жилээр (2020-2021)
    ## 685                                                              ИРГЭДИЙН ТӨЛӨӨЛӨГЧДИЙН ХУРЛЫН ТӨЛӨӨЛӨГЧДИЙН ТОО, хүйс, насны бүлэг, сум, дүүрэг, жилээр (2020-2021)
    ## 686                                                                     УЛСЫН ТӨСВӨӨС ОРОН НУТГИЙН ТӨСӨВТ ОЛГОСОН САНХYYГИЙН ДЭМЖЛЭГ, бүс, аймаг, нийслэлээр, жилээр
    ## 687                                                                                                          ОРОН НУТГИЙН ТӨСВИЙН ЗАРЛАГА, аймаг, нийслэлээр, жилээр
    ## 688                                                                                                           ОРОН НУТГИЙН ТӨСВИЙН ОРЛОГО, аймаг, нийслэлээр, жилээр
    ## 689                                                                                                                    ХҮНИЙ ХӨГЖЛИЙН ИНДЕКС, аймаг, нийслэл, жилээр
    ## 690                                                                                                                ЖЕНДЭРИЙН ХӨГЖЛИЙН ИНДЕКC, аймаг, нийслэл, жилээр
    ## 691                                                                                                  ЖЕНДЭРИЙН ТЭГШ БУС БАЙДЛЫН ИНДЕКС, хүйс, аймаг, нийслэл, жилээр
    ## 692                                                                                                        ЖЕНДЭРИЙН ТЭГШ БУС БАЙДЛЫН ИНДЕКС, аймаг, нийслэл, жилээр
    ## 693                                                                                                        ХҮНИЙ ХӨГЖЛИЙН БҮРЭЛДЭХҮҮН ИНДЕКС, аймаг, нийслэл, жилээр
    ## 694                                                         ХҮН БАЙНГА АМЬДАРДАГ БАЙШИНГИЙН ТОО, ханын үндсэн материал, бүс, аймаг, нийслэл, тооллого явагдсан оноор
    ## 695                                                                      ӨРХИЙН ТОО, цахилгааны эх үүсвэр, бүс, аймаг, нийслэл, сум, дүүрэг, тооллого явагдсан оноор
    ## 696                                                                 ӨРХИЙН ТОО, усан хангамжийн эх үүсвэр, бүс, аймаг, нийслэл, сум, дүүрэг, тооллого явагдсан оноор
    ## 697  ЦЭВЭРЛЭХ БАЙГУУЛАМЖ, АРИУТГАХ ТАТУУРГЫН ШУГАМ СҮЛЖЭЭНД ХОЛБОГДСОН БОЛОН ХОЛБОГДООГҮЙ НИЙТ ӨРХИЙН ТОО, бүс, аймаг, нийслэл, сум, дүүрэг, тооллого явагдсан оноор
    ## 698                     ТӨВЛӨРСӨН БОЛОН БИЕ ДААСАН ИНЖЕНЕРИЙН БҮРЭН ХАНГАМЖТАЙ ОРОН СУУЦАНД АМЬДАРДАГ ӨРХ, бүс, аймаг, нийслэл, сум, дүүрэг, тооллого явагдсан оноор
    ## 699                                           БАЙШИН, ГЭР БОЛОН БУСАД СУУЦАНД АМЬДАРДАГ ӨРХ, сууцны төрөл, бүс, аймаг, нийслэл, сум, дүүрэг, тооллого явагдсан оноор
    ## 700                                                                                                 ГЭМТ ХЭРГИЙН УЛМААС НАС БАРСАН ХҮНИЙ ТОО, бүс, аймаг, нийслэлээр
    ## 701                                                                                  АВЛИГАТАЙ ТЭМЦЭХ ГАЗАРТ БҮРТГЭГДСЭН ГЭМТ ХЭРГИЙН ТОО, хэргийн ангиллаар, жилээр
    ## 702                                                                                  АВЛИГАТАЙ ТЭМЦЭХ ГАЗАРТ БҮРТГЭГДСЭН ГЭМТ ХЭРГИЙН ТОО, хэргийн ангиллаар, сараар
    ## 703                                                                               Гэмт хэргийн улмаас учирсан хохирол, нөхөн төлүүлэлтийн хэмжээ, мэдээ жилээр (АТГ)
    ## 704                                                                                БҮРТГЭГДСЭН ГЭМТ ХЭРГИЙН ТОО, бүс, аймаг, нийслэлээр, сар, жилээр (өссөн дүнгээр)
    ## 705                                               БҮРТГЭГДСЭН ГЭМТ ХЭРЭГТ ХОЛБОГДСОН НИЙТ ЯЛЛАГДАГЧДЫН ТОО, бүс, аймаг, нийслэлээр, хүйсээр, насны ангиллаар, сараар
    ## 706                                               БҮРТГЭГДСЭН ГЭМТ ХЭРЭГТ ХОЛБОГДСОН НИЙТ ЯЛЛАГДАГЧДЫН ТОО, бүс, аймаг, нийслэлээр, хүйсээр, насны ангиллаар, сараар
    ## 707                                                                                                                ГЭМТСЭН ХҮНИЙ ТОО, бүс, аймаг, нийслэлээр, жилээр
    ## 708                                                                           ХҮНИЙ ЭРҮҮЛ МЭНДИЙН ХАЛДАШГҮЙ БАЙДЛЫН ЭСРЭГ ГЭМТ ХЭРЭГ, бүс, аймаг, нийслэлээр, жилээр
    ## 709                                                                               ХОХИРОГЧ БАЙГУУЛЛАГА, хариуцлагын хэлбэрээр, бүс, аймаг, нийслэл, дүүргээр, жилээр
    ## 710                                                                     ГЭМТ ХЭРГИЙН УЛМААС ХОХИРСОН ХҮНИЙ ТОО, бүс, аймаг, нийслэл, дүүргээр, насны бүлгээр, жилээр
    ## 711                                                                                                 ШҮҮХЭЭР ЯЛ ШИЙТГҮҮЛСЭН ХҮНИЙ ТОО, бүс, аймаг, нийслэлээр, жилээр
    ## 712                                                                                                  ХҮНИЙ АМЬД ЯВАХ ЭРХИЙН ЭСРЭГ ГЭМТ ХЭРЭГ, бүс, аймаг, нийслэлээр
    ## 713                                                                              ХҮНИЙ БЭЛГИЙН ЭРХ ЧӨЛӨӨ, ХАЛДАШГҮЙ БАЙДЛЫН ЭСРЭГ ГЭМТ ХЭРЭГ, бүс, аймаг, нийслэлээр
    ## 714                                                                                                           ӨМЧЛӨХ ЭРХИЙН ЭСРЭГ ГЭМТ ХЭРЭГ, бүс, аймаг, нийслэлээр
    ## 715                                                                                                                 МАЛ ХУЛГАЙЛАХ ГЭМТ ХЭРЭГ, бүс, аймаг, нийслэлээр
    ## 716                                                                             ОЛОН НИЙТИЙН АЮУЛГҮЙ БАЙДАЛ, АШИГ СОНИРХЛЫН ЭСРЭГ ГЭМТ ХЭРЭГ, бүс, аймаг, нийслэлээр
    ## 717                                                       ХӨДӨЛГӨӨНИЙ АЮУЛГҮЙ БАЙДАЛ, ТЭЭВРИЙН ХЭРЭГСЛИЙН АШИГЛАЛТЫН ЖУРМЫН ЭСРЭГ ГЭМТ ХЭРЭГ, бүс, аймаг, нийслэлээр
    ## 718                                                                                                                 ЭДИЙН ЗАСГИЙН ГЭМТ ХЭРЭГ, аймаг, нийслэл, жилээр
    ## 719                                                                                                                                 ХУУЛЬЧИД, бүс, аймаг, нийслэлээр
    ## 720                                                                                                           БҮРТГЭГДСЭН ЗАМ, ТЭЭВРИЙН ОСОЛ, бүс, аймаг, нийслэлээр
    ## 721                                                                      БҮРТГЭГДСЭН ГЭМТ ХЭРЭГ, үйлдэгдсэн байдлаар, бүс, аймаг, нийслэлээр, сараар (өссөн дүнгээр)
    ## 722                                                                                                               БҮРТГЭГДСЭН ЗӨРЧИЛ, бүс, аймаг, нийслэлээр, сараар
    ## 723                                                                                       ШҮҮХЭЭР ШИЙДВЭРЛҮҮЛСЭН ХӨДӨЛМӨРИЙН МАРГААН, бүс, аймаг, нийслэлээр, жилээр
    ## 724                                                                                                              БОЙЖУУЛСАН ТӨЛ, малын төрөл, аймаг, нийслэл, жилээр
    ## 725                                                                                                                   МАЛЫН ТОО, малын төрөл, аймаг, нийслэл, жилээр
    ## 726                                                                                                                              МАЛЧДЫН ТОО, аймаг, нийслэл, жилээр
    ## 727                                                                                                 ӨВЧНӨӨР ХОРОГДСОН МАЛЫН ТОО, малын төрөл, аймаг, нийслэл, жилээр
    ## 728                                                                                                                        МАЛЧИН ӨРХИЙН ТОО, аймаг, нийслэл, жилээр
    ## 729                                                                                                                        МАЛТАЙ ӨРХИЙН ТОО, аймаг, нийслэл, жилээр
    ## 730                                                                                                                            САРЛАГИЙН ТОО, аймаг, нийслэл, жилээр
    ## 731                                                                                                              ТЭЖЭЭВЭР АМЬТДЫН ТОО, төрөл, аймаг, нийслэл, жилээр
    ## 732                                                                                              ХЭЭЛ ХАЯСАН ХЭЭЛТЭГЧ МАЛЫН ТОО, малын төрөл, аймаг, нийслэл, жилээр
    ## 733                                                                                                СУВАЙРСАН ХЭЭЛТЭГЧ МАЛЫН ТОО, малын төрөл, аймаг, нийслэл, жилээр
    ## 734                                                                                                          ХЭЭЛТЭГЧ МАЛЫН ТОО, малын төрөл, аймаг, нийслэл, жилээр
    ## 735                                                                                                  ТОМ МАЛЫН ЗҮЙ БУС ХОРОГДОЛ, малын төрөл, аймаг, нийслэл, жилээр
    ## 736                                                                                                             СҮМ ХИЙДИЙН ТОО, шашны төрөл, аймаг, нийслэл, жилээр
    ## 737                                                                                                        ХУРЛЫН ЛАМ НАРЫН ТОО, шашны төрөл, аймаг, нийслэл, жилээр
    ## 738                                                                                      ШАШНЫ СУРГУУЛЬ ДАЦАНД СУРАЛЦАГЧДЫН ТОО, шашны төрөл, аймаг, нийслэл, жилээр
    ## 739                                                                                                           ЗЭЭЛИЙН ӨРИЙН ҮЛДЭГДЭЛ, бүс, аймаг, нийслэлээр, жилээр
    ## 740                                                                                                   ИРГЭДИЙН ХАДГАЛАМЖИЙН ҮЛДЭГДЭЛ, бүс, аймаг, нийслэлээр, жилээр
    ## 741                                                                                                  ЧАНАРГҮЙ ЗЭЭЛИЙН ӨРИЙН ҮЛДЭГДЭЛ, бүс, аймаг, нийслэлээр, жилээр
    ## 742                                                                                                               ДОТООДЫН НИЙТ БҮТЭЭГДЭХҮҮН, аймаг, нийслэл, жилээр
    ## 743                                                                                               НЭГ ХҮНД НОГДОХ ДОТООДЫН НИЙТ БҮТЭЭГДЭХҮҮН, аймаг, нийслэл, жилээр
    ## 744                                                                                                          ҮНДСЭН ХӨРӨНГИЙН НИЙТ ХУРИМТЛАЛ, аймаг, нийслэл, жилээр
    ## 745                                                                                              ДОТООДЫН НИЙТ БҮТЭЭГДЭХҮҮНИЙ САЛБАРЫН БҮТЭЦ, аймаг, нийслэл, жилээр
    ## 746                                                                                         ДОТООДЫН НИЙТ БҮТЭЭГДЭХҮҮН, эдийн засгийн салбар, аймаг, нийслэл, жилээр
    ## 747                                                                                                           УЛСЫН ТӨСВИЙН ХӨРӨНГӨ ОРУУЛАЛТ, аймаг, нийслэл, жилээр
    ## 748                                                                                                    ОРОН НУТГИЙН ТӨСВИЙН ХӨРӨНГӨ ОРУУЛАЛТ, аймаг, нийслэл, жилээр
    ## 749                                                                                        МОНГОЛ УЛСАД ОРШИН СУУГАА ЖИЛИЙН ДУНДАЖ ХҮН АМЫН ТОО, сум, дүүрэг, жилээр
    ## 750                                                                                                                    ХҮН АМЫН ТОО, байршил, аймаг, нийслэл, жилээр
    ## 751                                                                                             МОНГОЛ УЛСАД ОРШИН СУУГАА ХҮН АМЫН ТОО, байршил, сум, дүүрэг, жилээр
    ## 752                                                                                                                                  ӨРХИЙН ТОО, сум, дүүрэг, жилээр
    ## 753                                                                                                                         ӨРХИЙН ТОО, байршил, сум, дүүрэг, жилээр
    ## 754                                                                                                                  НАС БАРСАН ХҮНИЙ ТОО, хүйс, сум, дүүрэг, жилээр
    ## 755                                                                                                                      ТӨРӨЛТИЙН ТОО, хүйсээр, сум, дүүрэг, жилээр
    ## 756                                                                                                           НАС БАРСАН ХҮНИЙ ТОО, насны бүлэг, сум, дүүрэг, жилээр
    ## 757                                                                                                                       ГЭРЛЭЛ, ЦУЦЛАЛТЫН ТОО, сум, дүүрэг, жилээр
    ## 758                                                                                                ГЭРЛЭЛТЭЭ БҮРТГҮҮЛСЭН ХҮНИЙ ТОО, насны бүлэг, сум, дүүрэг, жилээр
    ## 759                                                                                                       ГЭРЛЭЛТ, ЦУЦЛАЛТ, 1000 хүнд ногдох, аймаг, нийслэл, жилээр
    ## 760                                                                                                    ТӨРСӨН ХҮҮХДИЙН ТОО, эхийн насны бүлгээр, сум, дүүрэг, жилээр
    ## 761                                                                                                      НАС БАРАЛТЫН ЕРӨНХИЙ КОЭФФИЦИЕНТ, хүйс, сум, дүүрэг, жилээр
    ## 762                                                                                                               ТӨРӨЛТИЙН ЕРӨНХИЙ КОЭФФИЦИЕНТ, сум, дүүрэг, жилээр
    ## 763                                                                                                            ХҮН АМЫН ДУНДАЖ НАСЛАЛТ, хүйс, аймаг, нийслэл, жилээр
    ## 764                                                                                                                 ТӨРӨХ ҮЕИЙН ХҮЙСИЙН ХАРЬЦАА, сум, дүүрэг, жилээр
    ## 765                                                                                                                            ХҮН АМЫН НЯГТРАЛ, сум, дүүрэг, жилээр
    ## 766                                                                                                                         ХҮН АМ ЗҮЙН АЧААЛАЛ, сум, дүүрэг, жилээр
    ## 767                                                                                          ХҮҮХЭД ТӨРҮҮЛСЭН ЭХЧҮҮДИЙН ТОО, боловсролын түвшин, сум, дүүрэг, жилээр
    ## 768                                                                                                                ХҮН АМЫН ШИЛЖИХ ХӨДӨЛГӨӨН, аймаг, нийслэл, жилээр
    ## 769                                                                                           ХҮҮХЭД ТӨРҮҮЛСЭН ЭХЧҮҮДИЙН ТОО, гэрлэлтийн байдал, сум, дүүрэг, жилээр
    ## 770                                                                                                                                     ҮРЧЛЭЛТ, сум, дүүрэг, жилээр
    ## 771                                                                                         МОНГОЛ УЛСАД ОРШИН СУУГАА ХҮН АМЫН ТОО, насны бүлэг, сум, дүүрэг, жилээр
    ## 772                                                                                                МОНГОЛ УЛСАД ОРШИН СУУГАА ХҮН АМЫН ТОО, хүйс, сум, дүүрэг, жилээр
    ## 773                                                                                                          НЭГ ӨРХИЙН САРЫН ДУНДАЖ ОРЛОГО, бүс, жилээр /2007-2024/
    ## 774                                                                                                         НЭГ ӨРХИЙН САРЫН ДУНДАЖ ЗАРЛАГА, бүс, жилээр /2007-2024/
    ## 775                                                                                                   НЭГ ӨРХИЙН САРЫН ДУНДАЖ ОРЛОГЫН БҮТЭЦ, бүс, жилээр /2007-2024/
    ## 776                                                                                                  НЭГ ӨРХИЙН САРЫН ДУНДАЖ ЗАРЛАГЫН БҮТЭЦ, бүс, жилээр /2007-2024/
    ## 777                                                                                   ТЭГШ БУС БАЙДАЛ, нэг хүнд сард ногдох хэрэглээнд үндэслэн тооцсон, бүс, жилээр
    ## 778                                                                                  ХЭРЭГЛЭЭНИЙ ҮНИЙН ИНДЕКС, өмнөх сартай харьцуулснаар, аймаг, нийслэлээр, сараар
    ## 779                                                                           ХЭРЭГЛЭЭНИЙ ҮНИЙН ИНДЕКС, өмнөх оны мөн үетэй харьцуулснаар, аймаг, нийслэлээр, сараар
    ## 780                                                                             ХЭРЭГЛЭЭНИЙ ҮНИЙН ИНДЕКС, өмнөх оны эцэстэй харьцуулснаар, аймаг, нийслэлээр, сараар
    ## 781                                                                                                            ХЭРЭГЛЭЭНИЙ ҮНИЙН УЛСЫН СУУРЬ ИНДЕКС, бүлгээр, сараар
    ## 782                                                                                                                    ХЭРЭГЛЭЭНИЙ ҮНИЙН УЛСЫН ИНДЕКС, 1991-1-16=100
    ## 783                                                                      ХЭРЭГЛЭЭНИЙ ҮНИЙН УЛСЫН ИНДЕКСИЙН ӨӨРЧЛӨЛТ, бүлгээр, өмнөх оны жилийн эцэстэй харьцуулснаар
    ## 784                                                                                         ХЭРЭГЛЭЭНИЙ ҮНИЙН УЛСЫН ИНДЕКСИЙН ӨӨРЧЛӨЛТ, бүлгээр, сар бүрийн өөрчлөлт
    ## 785                                                                           ХЭРЭГЛЭЭНИЙ ҮНИЙН УЛСЫН ИНДЕКСИЙН ӨӨРЧЛӨЛТ, бүлгээр, өмнөх оны мөн үетэй харьцуулснаар
    ## 786                                                                                                                                   ИНФЛЯЦЫН ЖИЛИЙН ТҮВШИН, хувиар
    ## 787                                                             ДНБ-Д ЖИЖИГ, ДУНД ҮЙЛДВЭР, ҮЙЛЧИЛГЭЭ ЭРХЛЭГЧДИЙН НЭМЭГДЭЛ ӨРТГИЙН ЭЗЛЭХ ХУВЬ, аймаг, нийслэл, жилээр
    ## 788                                                                                    ЖИЖИГ, ДУНД ҮЙЛДВЭР, ҮЙЛЧИЛГЭЭ ЭРХЛЭГЧ ХУУЛИЙН ЭТГЭЭД, аймаг, нийслэл, жилээр
    ## 789                                                                                            БИЗНЕС РЕГИСТРИЙН САНД БҮРТГЭЛТЭЙ ХОРШОО, ГИШҮҮД, сум, дүүрэг, жилээр
    ## 790                                                                 БИЗНЕС РЕГИСТРИЙН САНД БҮРТГЭЛТЭЙ ХОРШООНЫ ХУВЬ НИЙЛҮҮЛСЭН ХӨРӨНГИЙН ХЭМЖЭЭ, сум, дүүрэг, жилээр
    ## 791                                                                          ҮЙЛ АЖИЛЛАГАА ЯВУУЛЖ БАЙГАА ХУУЛИЙН ЭТГЭЭДИЙН ТОО, өмчийн хэлбэр, сум, дүүрэг, улирлаар
    ## 792                                                                ҮЙЛ АЖИЛЛАГАА ЯВУУЛЖ БАЙГАА ХУУЛИЙН ЭТГЭЭДИЙН ТОО, ажиллагчдын тооны бүлэг, сум, дүүрэг, улирлаар
    ## 793                                                  БИЗНЕС РЕГИСТРИЙН САНД БҮРТГЭЛТЭЙ ХУУЛИЙН ЭТГЭЭДИЙН ТОО, үйл ажиллагаа эрхлэлтийн байдал, сум, дүүрэг, улирлаар
    ## 794                                                                     ҮЙЛ АЖИЛЛАГАА ЯВУУЛЖ БАЙГАА ХУУЛИЙН ЭТГЭЭДИЙН ТОО, хариуцлагын хэлбэр, сум, дүүрэг, улирлаар
    ## 795                                                     ҮЙЛ АЖИЛЛАГАА ЯВУУЛЖ БАЙГАА ХУУЛИЙН ЭТГЭЭДИЙН ТОО, эдийн засгийн үйл ажиллагаа салбар, сум, дүүрэг, улирлаар
    ## 796                                                                                  МОНГОЛ УЛСЫН ЗАСАГ ЗАХИРГАА, НУТАГ ДЭВСГЭРИЙН НЭГЖ, бүс, аймаг, нийслэл, жилээр
    ## 797                                                                                              ХУДАЛДААНЫ САЛБАРЫН НИЙТ БОРЛУУЛАЛТ, бүс, аймаг, нийслэлээр, сараар
    ## 798                                                                                              ХУДАЛДААНЫ САЛБАРЫН НИЙТ БОРЛУУЛАЛТ, бүс, аймаг, нийслэлээр, жилээр
    ## 799                                                                                   ЗОЧИД БУУДЛЫН САЛБАРЫН ОРЛОГО, бүс, аймаг, нийслэлээр, улирлаар, өссөн дүнгээр
    ## 800                                                                                     ЗОЧИД БУУДЛЫН САЛБАРЫН ОРЛОГО, бүс, аймаг, нийслэлээр, сараар, өссөн дүнгээр
    ## 801                                                                                  НИЙТИЙН ХООЛНЫ САЛБАРЫН ОРЛОГО, бүс, аймаг, нийслэлээр, улирлаар, өссөн дүнгээр
    ## 802                                                                                    НИЙТИЙН ХООЛНЫ САЛБАРЫН ОРЛОГО, бүс, аймаг, нийслэлээр, сараар, өссөн дүнгээр
    ## 803                                                                                                         АВТО ЗАМЫН ТЭЭВРИЙН ҮНДСЭН ҮЗҮҮЛЭЛТ, улсын дүн, улирлаар
    ## 804                                                                                                          БҮХ ТӨРЛИЙН ТЭЭВРИЙН ҮНДСЭН ҮЗҮҮЛЭЛТ, улсын дүн, жилээр
    ## 805                                                                                                   АГААРЫН ТЭЭВРИЙН ЗОРЧИГЧ, чиглэл тус бүрээр, улсын дүн, сараар
    ## 806                                                                                                              АГААРЫН ТЭЭВРИЙН ҮНДСЭН ҮЗҮҮЛЭЛТ, улсын дүн, сараар
    ## 807                                                                                                          ТӨМӨР ЗАМЫН ТЭЭВРИЙН ҮНДСЭН ҮЗҮҮЛЭЛТ, улсын дүн, сараар
    ## 808                                                        ТЕХНИКИЙН ХЯНАЛТЫН ҮЗЛЭГТ ХАМРАГДСАН АВТО МАШИНЫ ТОО, төрлөөр, бүс, аймаг, нийслэл, сум, дүүргээр, жилээр
    ## 809                                                     ТЕХНИКИЙН ХЯНАЛТЫН ҮЗЛЭГТ ХАМРАГДСАН АВТО МАШИНЫ ТОО, насжилтаар, бүс, аймаг, нийслэл, сум, дүүргээр, жилээр
    ## 810                                                                                      БҮРТГЭЛТЭЙ ТЭЭВРИЙН ХЭРЭГСЛИЙН ТОО, төрлөөр, бүс, аймаг, нийслэлээр, жилээр
    ## 811                                                                                   БҮРТГЭЛТЭЙ ТЭЭВРИЙН ХЭРЭГСЛИЙН ТОО, насжилтаар, бүс, аймаг, нийслэлээр, жилээр
    ## 812                                                                                        ИМПОРТООР ОРУУЛЖ ИРСЭН АВТОМАШИНЫ ТОО, улсаар, автомашины төрлөөр, жилээр
    ## 813                                                                                             КАБЕЛИЙН ТЕЛЕВИЗ ХЭРЭГЛЭГЧДИЙН ТОО, бүс, аймаг, нийслэлээр, улирлаар
    ## 814                                                                                          ИНТЕРНЭТ ХЭРЭГЛЭГЧ БА КОМПЬЮТЕРЫН ТОО, бүс, аймаг, нийслэлээр, улирлаар
    ## 815                                                                                 ХАРИЛЦАА ХОЛБООНЫ ҮЙЛЧИЛГЭЭНИЙ ҮНДСЭН ҮЗҮҮЛЭЛТ, бүс, аймаг, нийслэлээр, улирлаар
    ## 816                                                                                                   ШУУДАНГИЙН ҮЙЛЧИЛГЭЭНИЙ ҮЗҮҮЛЭЛТ, шуудангийн төрлөөр, улирлаар
    ## 817                                                           МЭДЭЭЛЭЛ, ХАРИЛЦАА ХОЛБООНЫ САЛБАРЫН ОРЛОГО, үйл ажиллагааны төрлөөр, бүс, аймаг, нийслэлээр, улирлаар
    ## 818                                                                                                     ХӨГЖЛИЙН БЭРХШЭЭЛТЭЙ ХҮНИЙ ТОО, хүйс, аймаг, нийслэл, жилээр
    ## 819                                                                                                                        ХӨГЖЛИЙН БЭРХШЭЭЛТЭЙ ХҮНИЙ ТОО, хэлбэрээр
    ## 820                                                                                                   ХАРААНЫ ХӨГЖЛИЙН БЭРХШЭЭЛТЭЙ ХҮН, хүйс, аймаг, нийслэл, жилээр
    ## 821                                                                                           СОНСГОЛЫН ХӨГЖЛИЙН БЭРХШЭЭЛТЭЙ ХҮНИЙ ТОО, хүйс, аймаг, нийслэл, жилээр
    ## 822                                                                                          ХЭЛ ЯРИАНЫ ХӨГЖЛИЙН БЭРХШЭЭЛТЭЙ ХҮНИЙ ТОО, хүйс, аймаг, нийслэл, жилээр
    ## 823                                                                                         ХӨДӨЛГӨӨНИЙ ХӨГЖЛИЙН БЭРХШЭЭЛТЭЙ ХҮНИЙ ТОО, хүйс, аймаг, нийслэл, жилээр
    ## 824                                                                                           СЭТГЭЦИЙН ХӨГЖЛИЙН БЭРХШЭЭЛТЭЙ ХҮНИЙ ТОО, хүйс, аймаг, нийслэл, жилээр
    ## 825                                                                                 ХАВСАРСАН ХЭЛБЭРИЙН ХӨГЖЛИЙН БЭРХШЭЭЛТЭЙ ХҮНИЙ ТОО, хүйс, аймаг, нийслэл, жилээр
    ## 826                                                                                       БУСАД ТӨРЛИЙН ХӨГЖЛИЙН БЭРХШЭЭЛТЭЙ ХҮНИЙ ТОО, хүйс, аймаг, нийслэл, жилээр
    ## 827                                                                                                   МОНГОЛ УЛСЫН ЕРӨНХИЙЛӨГЧИЙН СОНГУУЛИЙН ДҮН (сонгуулийн жилээр)
    ## 828                                                                                  УЛСЫН ИХ ХУРЛЫН ГИШҮҮД, ИРГЭДИЙН ХУРЛЫН ТӨЛӨӨЛӨГЧИД, намаар (сонгуулийн жилээр)
    ## 829                                                                                                                           СОНГОГЧДЫН ОРОЛЦОО (сонгуулийн жилээр)
    ## 830                                                                                           МОНГОЛ УЛСЫН ИХ ХУРЛЫН ГИШҮҮД, хүйс, насны бүлгээр (сонгуулийн жилээр)
    ## 831                                                                                   МОНГОЛ УЛСЫН ИХ ХУРЛЫН ГИШҮҮД, мэргэжлээр, дүнд эзлэх хувь (сонгуулийн жилээр)
    ## 832                                                                              ЖИШСЭН ХҮН АМЫН ЖИЛИЙН ХҮНСНИЙ ХЭРЭГЦЭЭ, улсын дундаж, бүтээгдэхүүний төрөл, жилээр
    ## 833                                                                                            ХҮНСНИЙ ХАНГАМЖИЙН ТҮВШИН, улсын дундаж, бүтээгдэхүүний төрөл, жилээр
    ## 834                                                              ЖИШСЭН ДУНДАЖ НЭГ ХҮНИЙ ХҮНСНЭЭС АВЧ БУЙ БОДИТ ИЛЧЛЭГ ШИМ ТЭЖЭЭЛ, сэрүүний улиралд, байршил, жилээр
    ## 835                                                                  ЖИШСЭН ДУНДАЖ НЭГ ХҮНИЙ ХҮНСНЭЭС АВЧ БУЙ БОДИТ ИЛЧЛЭГ ШИМ ТЭЖЭЭЛ, зуны улиралд, байршил, жилээр
    ## 836                                                                                                 ХҮНСНИЙ ХАНГАМЖИЙН ХУВЬ, эх үүсвэр, бүтээгдэхүүний төрөл, жилээр
    ## 837                                                                                                           ХҮНСНИЙ ХҮРТЭЭМЖ, улирал, бүтээгдэхүүний төрөл, жилээр
    ## 838                                                                                 ХҮНСНИЙ БАТАЛГААТ БАЙДЛЫН АЛДАГДАЛТАЙ ӨРХИЙН ХУВЬ, улсын дундаж, байршил, жилээр
    ## 839                                                                               ХҮНСНИЙ БАТАЛГААТ БАЙДЛЫН АЛДАГДАЛТАЙ ХҮН АМЫН ХУВЬ, улсын дундаж, байршил, жилээр
    ## 840                                                                             ИРГЭДИЙН ТӨЛӨӨЛӨГЧДИЙН ХУРЛЫН ТӨЛӨӨЛӨГЧИД, хүйс, насны бүлэг, аймаг, нийслэл, жилээр
    ## 841                                                                                ИРГЭДИЙН ТӨЛӨӨЛӨГЧДИЙН ХУРЛЫН ТӨЛӨӨЛӨГЧИД, хүйс, насны бүлэг, сум, дүүрэг, жилээр
    ## 842                                                                 ИРГЭДИЙН ТӨЛӨӨЛӨГЧДИЙН ХУРЛЫН ТӨЛӨӨЛӨГЧИД, хүйс, насны бүлэг, аймаг, нийслэл, жилээр (2020-2021)
    ## 843                                                              ИРГЭДИЙН ТӨЛӨӨЛӨГЧДИЙН ХУРЛЫН ТӨЛӨӨЛӨГЧДИЙН ТОО, хүйс, насны бүлэг, сум, дүүрэг, жилээр (2020-2021)
    ## 844                                                                                   СҮҮЛИЙН 12 САРД ХҮЧИРХИЙЛЭЛД ӨРТСӨН ЭМЭГТЭЙЧҮҮДИЙН ХУВЬ, 15-49 болон 15-64 нас
    ## 845                                              СҮҮЛИЙН 12 САРД ХҮЧИРХИЙЛЭЛД ӨРТСӨН ЭМЭГТЭЙЧҮҮДИЙН ХУВЬ, 15-49 болон 15-64 нас, хүчирхийллийн хэлбэр, насны бүлгээр
    ## 846                                                                                           БУСДЫН ЗҮГЭЭС ҮЙЛДСЭН ХҮЧИРХИЙЛЭЛ, хүчирхийллийн хэлбэр, насны бүлгээр
    ## 847                                                                                  БУСДЫН ЗҮГЭЭС ҮЙЛДСЭН ХҮЧИРХИЙЛЭЛ, хүчирхийллийн хэлбэр, хүчирхийлэл үйлдэгчээр
    ## 848                                                                                БУСДЫН ЗҮГЭЭС ҮЙЛДСЭН ХҮЧИРХИЙЛЭЛ, хүчирхийллийн хэлбэр, хүчирхийллийн давтамжаар
    ## 849                                                                                      ХАМТРАГЧИЙН ЗҮГЭЭС ҮЙЛДСЭН ХҮЧИРХИЙЛЭЛ, хүчирхийллийн хэлбэр, насны бүлгээр
    ## 850                                                                              ХАМТРАГЧИЙН ЗҮГЭЭС ҮЙЛДСЭН ХҮЧИРХИЙЛЭЛ, хүчирхийллийн хэлбэр, хамтрагчийн статусаар
    ## 851                                                                           ХАМТРАГЧИЙН ЗҮГЭЭС ҮЙЛДСЭН ХҮЧИРХИЙЛЭЛ, хүчирхийллийн хэлбэр, хүчирхийллийн давтамжаар
    ## 852                                                                                                                 СУДАЛГААНД ХАМРАГДСАН ЭМЭГТЭЙЧҮҮД, хот хөдөөгөөр
    ## 853                                                                                                        СУДАЛГААНД ХАМРАГДСАН ЭМЭГТЭЙЧҮҮД, бүс, аймаг, нийслэлээр
    ## 854                                                                                                                 СУДАЛГААНД ХАМРАГДСАН ЭМЭГТЭЙЧҮҮД, насны бүлгээр
    ## 855                                                                                                          СУДАЛГААНД ХАМРАГДСАН ЭМЭГТЭЙЧҮҮД, боловсролын түвшнээр
    ## 856                                                                                                                     СУДАЛГААНД ХАМРАГДСАН ЭМЭГТЭЙЧҮҮД, байршлаар
    ## 857                                                                      АМЬДРАЛДАА ХАМТРАГЧИЙН ХҮЧИРХИЙЛЭЛД ӨРТСӨН ЭМЭГТЭЙЧҮҮД, хүчирхийллийн хэлбэр, хот хөдөөгөөр
    ## 858                                                                          АМЬДРАЛДАА ХАМТРАГЧИЙН ХҮЧИРХИЙЛЭЛД ӨРТСӨН ЭМЭГТЭЙЧҮҮД, хүчирхийллийн хэлбэр, байршлаар
    ## 859                                                             АМЬДРАЛДАА ХАМТРАГЧИЙН ХҮЧИРХИЙЛЭЛД ӨРТСӨН ЭМЭГТЭЙЧҮҮД, хүчирхийллийн хэлбэр, бүс, аймаг, нийслэлээр
    ## 860                                                                      АМЬДРАЛДАА ХАМТРАГЧИЙН ХҮЧИРХИЙЛЭЛД ӨРТСӨН ЭМЭГТЭЙЧҮҮД, хүчирхийллийн хэлбэр, насны бүлгээр
    ## 861                                                                                     АМЬДРАЛДАА ХАМТРАГЧИЙН ХҮЧИРХИЙЛЭЛД ӨРТСӨН ЭМЭГТЭЙЧҮҮД, боловсролын түвшнээр
    ## 862                                                                 СҮҮЛИЙН 12 САРД ХАМТРАГЧИЙН ХҮЧИРХИЙЛЭЛД ӨРТСӨН ЭМЭГТЭЙЧҮҮД, хүчирхийллийн хэлбэр, хот хөдөөгөөр
    ## 863                                                                     СҮҮЛИЙН 12 САРД ХАМТРАГЧИЙН ХҮЧИРХИЙЛЭЛД ӨРТСӨН ЭМЭГТЭЙЧҮҮД, хүчирхийллийн хэлбэр, байршлаар
    ## 864                                                        СҮҮЛИЙН 12 САРД ХАМТРАГЧИЙН ХҮЧИРХИЙЛЭЛД ӨРТСӨН ЭМЭГТЭЙЧҮҮД, хүчирхийллийн хэлбэр, бүс, аймаг, нийслэлээр
    ## 865                                                                 СҮҮЛИЙН 12 САРД ХАМТРАГЧИЙН ХҮЧИРХИЙЛЭЛД ӨРТСӨН ЭМЭГТЭЙЧҮҮД, хүчирхийллийн хэлбэр, насны бүлгээр
    ## 866                                                          СҮҮЛИЙН 12 САРД ХАМТРАГЧИЙН ХҮЧИРХИЙЛЭЛД ӨРТСӨН ЭМЭГТЭЙЧҮҮД, хүчирхийллийн хэлбэр, боловсролын түвшнээр
    ## 867                                                                                                      НЭГ ӨРХИЙН САРЫН ДУНДАЖ ОРЛОГО, байршил, жилээр /1997-2024/
    ## 868                                                                                                          НЭГ ӨРХИЙН САРЫН ДУНДАЖ ОРЛОГО, бүс, жилээр /2007-2024/
    ## 869                                                                                                     НЭГ ӨРХИЙН САРЫН ДУНДАЖ ЗАРЛАГА, байршил, жилээр /1997-2024/
    ## 870                                                                                                         НЭГ ӨРХИЙН САРЫН ДУНДАЖ ЗАРЛАГА, бүс, жилээр /2007-2024/
    ## 871                                                                                               НЭГ ӨРХИЙН САРЫН ДУНДАЖ ОРЛОГЫН БҮТЭЦ, байршил, жилээр /1997-2024/
    ## 872                                                                                                   НЭГ ӨРХИЙН САРЫН ДУНДАЖ ОРЛОГЫН БҮТЭЦ, бүс, жилээр /2007-2024/
    ## 873                                                                                              НЭГ ӨРХИЙН САРЫН ДУНДАЖ ЗАРЛАГЫН БҮТЭЦ, байршил, жилээр /1997-2024/
    ## 874                                                                                                  НЭГ ӨРХИЙН САРЫН ДУНДАЖ ЗАРЛАГЫН БҮТЭЦ, бүс, жилээр /2007-2024/
    ## 875                                                             НЭГ ХҮНД САРД НОГДОХ ХҮНСНИЙ ЗАРИМ БҮТЭЭГДЭХҮҮНИЙ УЛСЫН ДУНДАЖ ХЭРЭГЛЭЭ, жишсэн хүн, байршил, жилээр
    ## 876                                                                 НЭГ ХҮНИЙ ХОНОГТ ХЭРЭГЛЭСЭН ХҮНСНИЙ БҮТЭЭГДЭХҮҮНИЙ ИЛЧЛЭГ, НАЙРЛАГА, жишсэн хүн, байршил, жилээр
    ## 877                                                                                              НЭГ ӨРХИЙН ЖИЛИЙН ДУНДАЖ МӨНГӨН ОРЛОГО, байршил, жилээр /1966-1996/
    ## 878                                                                                             НЭГ ӨРХИЙН ЖИЛИЙН ДУНДАЖ МӨНГӨН ЗАРЛАГА, байршил, жилээр /1966-1996/
    ## 879                                                                                                               НЭГ ӨРХИЙН САРЫН ДУНДАЖ ОРЛОГО, суурьшил, улирлаар
    ## 880                                                                                                              НЭГ ӨРХИЙН САРЫН ДУНДАЖ ЗАРЛАГА, суурьшил, улирлаар
    ## 881                                                                                                        НЭГ ӨРХИЙН САРЫН ДУНДАЖ ОРЛОГЫН БҮТЭЦ, суурьшил, улирлаар
    ## 882                                                                                                       НЭГ ӨРХИЙН САРЫН ДУНДАЖ ЗАРЛАГЫН БҮТЭЦ, суурьшил, улирлаар
    ## 883                                                                                    МӨНГӨН ОРЛОГО, ЗАРЛАГЫН БҮЛЭГЛЭЛТ, өрхийн дүнд эзлэх хувь, суурьшил, улирлаар
    ## 884                                                                                       МӨНГӨН ОРЛОГЫН БҮЛЭГЛЭЛТ, өрхийн дүнд эзлэх хувь, байршил, оны үнэ, жилээр
    ## 885                                                                                      МӨНГӨН ЗАРЛАГЫН БҮЛЭГЛЭЛТ, өрхийн дүнд эзлэх хувь, байршил, оны үнэ, жилээр
    ## 886                                                                                             ЖИНИ ИНДЕКС, нэг хүнд сард ногдох зардалд үндэслэн тооцсон, улирлаар
    ## 887                                                                                          ТЕЙЛИЙН ИНДЕКС, нэг хүнд сард ногдох зардалд үндэслэн тооцсон, улирлаар
    ## 888                                                                                                                    ХҮНИЙ ХӨГЖЛИЙН ИНДЕКС, аймаг, нийслэл, жилээр
    ## 889                                                                                      ХҮНИЙ ХӨГЖЛИЙН ТЭГШ БУС БАЙДЛААР ЗАСВАРЛАСАН ИНДЕКС, аймаг, нийслэл, жилээр
    ## 890                                                                                                                ЖЕНДЭРИЙН ХӨГЖЛИЙН ИНДЕКC, аймаг, нийслэл, жилээр
    ## 891                                                                                                  ЖЕНДЭРИЙН ТЭГШ БУС БАЙДЛЫН ИНДЕКС, хүйс, аймаг, нийслэл, жилээр
    ## 892                                                                                                            ЖЕНДЭРИЙН ЭРХ МЭДЛИЙН ХЭМЖҮҮР, аймаг, нийслэл, жилээр
    ## 893                                                                                                        ЖЕНДЭРИЙН ТЭГШ БУС БАЙДЛЫН ИНДЕКС, аймаг, нийслэл, жилээр
    ## 894                                                                                                        ХҮНИЙ ХӨГЖЛИЙН БҮРЭЛДЭХҮҮН ИНДЕКС, аймаг, нийслэл, жилээр
    ## 895                                                                                                 ГЭМТ ХЭРГИЙН УЛМААС НАС БАРСАН ХҮНИЙ ТОО, аймаг, нийслэл, жилээр
    ## 896                                                                                     ГЭМТ ХЭРГИЙН УЛМААС УЧИРСАН ХОХИРОЛ, НӨХӨН ТӨЛҮҮЛЭЛТ, аймаг, нийслэл, жилээр
    ## 897                                                                                                                  ӨРГӨДӨЛ, ГОМДОЛ, МЭДЭЭЛЛИЙН ШИЙДВЭРЛЭЛТ, жилээр
    ## 898                                                                   АВЛИГАТАЙ ТЭМЦЭХ ГАЗРЫН ХУВИЙН АШИГ СОНИРХЛЫН БОЛОН ХӨРӨНГӨ, ОРЛОГЫН МЭДҮҮЛГИЙН ТАЙЛАН, жилээр
    ## 899                                                                                                                   ШҮҮХЭЭР ЯЛ ШИЙТГҮҮЛСЭН ХҮНИЙ ТОО, хүйс, жилээр
    ## 900                                                                                               БҮРТГЭГДСЭН ГЭМТ ХЭРГИЙН ТОО, хэргийн ангилал, сум, дүүрэг, жилээр
    ## 901                                                                                                ГЭМТ ХЭРГИЙН УЛМААС ХОХИРСОН ХҮНИЙ ТОО, хүйс, сум, дүүрэг, жилээр
    ## 902                                                                    ГЭМТ ХЭРГИЙН УЛМААС УЧИРСАН ХОХИРОЛ БОЛОН НӨХӨН ТӨЛҮҮЛЭЛТ, өмчийн хэлбэр, сум, дүүрэг, жилээр
    ## 903                                                                                                                        ГЭМТСЭН ХҮНИЙ ТОО, аймаг, нийслэл, жилээр
    ## 904                                                                                    ХҮНИЙ ЭРҮҮЛ МЭНДИЙН ХАЛДАШГҮЙ БАЙДЛЫН ЭСРЭГ ГЭМТ ХЭРЭГ аймаг, нийслэл, жилээр
    ## 905                                                                                                 ХОХИРОГЧ БАЙГУУЛЛАГА, хариуцлагын хэлбэр, аймаг, нийслэл, жилээр
    ## 906                                                                                      ГЭМТ ХЭРГИЙН УЛМААС ХОХИРСОН ХҮНИЙ ТОО, насны бүлэг, аймаг, нийслэл, жилээр
    ## 907                                                                                                         ШҮҮХЭЭР ЯЛ ШИЙТГҮҮЛСЭН ХҮНИЙ ТОО, аймаг, нийслэл, жилээр
    ## 908                                                                                                  ХҮНИЙ АМЬД ЯВАХ ЭРХИЙН ЭСРЭГ ГЭМТ ХЭРЭГ, аймаг, нийслэл, жилээр
    ## 909                                                                              ХҮНИЙ БЭЛГИЙН ЭРХ ЧӨЛӨӨ, ХАЛДАШГҮЙ БАЙДЛЫН ЭСРЭГ ГЭМТ ХЭРЭГ, аймаг, нийслэл, жилээр
    ## 910                                                                                                           ӨМЧЛӨХ ЭРХИЙН ЭСРЭГ ГЭМТ ХЭРЭГ, аймаг, нийслэл, жилээр
    ## 911                                                                                                                 МАЛ ХУЛГАЙЛАХ ГЭМТ ХЭРЭГ, аймаг, нийслэл, жилээр
    ## 912                                                                             ОЛОН НИЙТИЙН АЮУЛГҮЙ БАЙДАЛ, АШИГ СОНИРХЛЫН ЭСРЭГ ГЭМТ ХЭРЭГ, аймаг, нийслэл, жилээр
    ## 913                                                       ХӨДӨЛГӨӨНИЙ АЮУЛГҮЙ БАЙДАЛ, ТЭЭВРИЙН ХЭРЭГСЛИЙН АШИГЛАЛТЫН ЖУРМЫН ЭСРЭГ ГЭМТ ХЭРЭГ, аймаг, нийслэл, жилээр
    ## 914                                                                                                                 ЭДИЙН ЗАСГИЙН ГЭМТ ХЭРЭГ, аймаг, нийслэл, жилээр
    ## 915                                                                                                                               АНХАН ШАТНЫ ШҮҮХИЙН ТАЙЛАН, жилээр
    ## 916                                                                                                                        ДАВЖ ЗААЛДАХ ШАТНЫ ШҮҮХИЙН ТАЙЛАН, жилээр
    ## 917                                                                                                                            ХЯНАЛТЫН ШАТНЫ ШҮҮХИЙН ТАЙЛАН, жилээр
    ## 918                                                                     16, ТҮҮНЭЭС ДЭЭШ НАСНЫ 10000 ХҮНД НОГДОХ БҮРТГЭГДСЭН ГЭМТ ХЭРЭГ, бүс, аймаг, нийслэл, жилээр
    ## 919                                                                                                    ХОХИРСОН ХҮН, хүйс, насны ангилал, гэмт хэргийн төрөл, жилээр
    ## 920                                                        16, ТҮҮНЭЭС ДЭЭШ НАСНЫ 10000 ХҮНД НОГДОХ ШҮҮХЭЭР ШИЙДВЭРЛЭСЭН ЭРҮҮГИЙН ХЭРЭГ, бүс, аймаг, нийслэл, жилээр
    ## 921                                                                                                                                 ХУУЛЬЧИД, аймаг, нийслэл, жилээр
    ## 922                                                                                                                            ХУУЛЬЧИД, ажил мэргэжил, хүйс, жилээр
    ## 923                                                                                                                   ШҮҮХЭЭР ЯЛ ШИЙТГҮҮЛСЭН ХҮН, ялын төрөл, жилээр
    ## 924                                                                                                                                    ХУУЛЬЧИД, насны бүлэг, жилээр
    ## 925                                                                                                                              ХУУЛЬЧИД, боловсролын зэрэг, жилээр
    ## 926                                                                                                        ХУУЛЬЧИЙН МЭРГЭЖЛИЙН ШАЛГАЛТАД ТЭНЦСЭН ЭРХ ЗҮЙЧИД, жилээр
    ## 927                                                                                                               ГЭМТ ХЭРГИЙН ЯЛЛАГДАГЧ, гэмт хэргийн төрөл, жилээр
    ## 928                                                                                                           БҮРТГЭГДСЭН ЗАМ, ТЭЭВРИЙН ОСОЛ, аймаг, нийслэл, жилээр
    ## 929                                                                                   ЗАМ ТЭЭВРИЙН ОСЛЫН УЛМААС НАС БАРСАН БОЛОН ГЭМТСЭН ХҮН, аймаг, нийслэл, жилээр
    ## 930                                                                                                 ЗАМ ТЭЭВРИЙН ОСЛЫН УЛМААС НАС БАРСАН ХҮН, аймаг, нийслэл, жилээр
    ## 931                                                                                                           ШҮҮХЭЭР ШИЙДВЭРЛЭСЭН ХЭРЭГ, гэмт хэргийн төрөл, жилээр
    ## 932                                                                                                        ГЭР БҮЛИЙН ТУХАЙ ХУУЛИЙН ДАГУУ ШИЙДВЭРЛЭСЭН ХЭРЭГ, жилээр
    ## 933                                                                                                                  ХҮҮХДИЙН ТЭТГЭЛГИЙН ТӨЛБӨР БАРАГДУУЛАЛТ, жилээр
    ## 934                                                                                                ХҮҮХДИЙН ТЭТГЭЛГИЙН ТӨЛБӨР БАРАГДУУЛАЛТ, төлбөрийн хэлбэр, жилээр
    ## 935                                                                                БҮРТГЭГДСЭН ГЭМТ ХЭРЭГ, үйлдэгдсэн байдал, аймаг, нийслэл, сараар (өссөн дүнгээр)
    ## 936                                                                                                       БҮРТГЭГДСЭН ЗӨРЧИЛ, аймаг, нийслэл, сараар (өссөн дүнгээр)
    ## 937                                                                                                  БҮРТГЭГДСЭН ГЭМТ ХЭРЭГ, гэмт хэргийн төрөл, сум, дүүрэг, жилээр
    ## 938                                                                                          ШҮҮХЭЭР ШИЙДВЭРЛҮҮЛСЭН ХӨДӨЛМӨРИЙН МАРГААН, бүс, аймаг, нийслэл, жилээр
    ## 939                                                                                                                                                  ЯДУУРЛЫН ТҮВШИН
    ## 940                                                                                                                                          ЯДУУРЛЫН ТҮВШИН, бүсээр
    ## 941                                                                                                                     ЯДУУРЛЫН ГҮНЗГИЙРЭЛТ, хот, хөдөө, суурьшлаар
    ## 942                                                                                                                                     ЯДУУРЛЫН ГҮНЗГИЙРЭЛТ, бүсээр
    ## 943                                                                          YНДЭСНИЙ НИЙТ ХЭРЭГЛЭЭНД ХАМГИЙН БАГА ХЭРЭГЛЭЭТЭЙ ХҮН АМЫН ХЭРЭГЛЭЭНИЙ ЭЗЛЭХ ХУВИЙН ЖИН
    ## 944                                                                                                                       НЭГ ХҮНД НОГДОХ ДОТООДЫН НИЙТ БҮТЭЭГДЭХҮҮН
    ## 945                                                                                                               АЖИЛЛАХ ХҮЧНИЙ ОРОЛЦООНЫ ТҮВШИН, аймаг, нийслэлээр
    ## 946                                                                                                   15-24 НАСНЫ ЗАЛУУЧУУДЫН АЖИЛГҮЙДЛИЙН ТҮВШИН, аймаг, нийслэлээр
    ## 947                                                                                             БАГА БОЛОВСРОЛЫН ХАМРАН СУРГАЛТЫН ЦЭВЭР ЖИН, аймаг, нийслэлээр, хувь
    ## 948                                                                             НЭГДҮГЭЭР АНГИД ЭЛСЭН ОРООД 5 ДУГААР АНГИ ХҮРТЭЛ СУРАЛЦАГДЫН ХУВЬ, аймаг, нийслэлээр
    ## 949                                                                                          15-24 НАСНЫ ЗАЛУУЧУУДЫН БИЧИГ ҮСЭГ ТАЙЛАГДАЛТЫН ХУВЬ, аймаг, нийслэлээр
    ## 950                                                                                        БАГА БОЛОВСРОЛ ЭЗЭМШИЖ БАЙГАА ОХИД, ХӨВГҮҮДИЙН ХАРЬЦАА, аймаг, нийслэлээр
    ## 951                                                                                     ЕРӨНХИЙ БОЛОВСРОЛ ЭЗЭМШИЖ БАЙГАА ОХИД, ХӨВГҮҮДИЙН ХАРЬЦАА, аймаг, нийслэлээр
    ## 952                                                                           ДЭЭД БОЛОВСРОЛ ЭЗЭМШИЖ БАЙГАА ЭМЭГТЭЙ, ЭРЭГТЭЙЧҮҮДИЙН ТООНЫ ХАРЬЦАА, аймаг, нийслэлээр
    ## 953                                                                        ХӨДӨӨ АЖ АХУЙН БУС САЛБАРТ ЦАЛИНТАЙ АЖИЛЛАГЧ ЭМЭГТЭЙЧҮҮДИЙН ХУВИЙН ЖИН, аймаг, нийслэлээр
    ## 954                                                                                                             УЛСЫН ИХ ХУРАЛД СОНГОГДСОН ЭМЭГТЭЙЧҮҮДИЙН ЭЗЛЭХ ХУВЬ
    ## 955                                                                                                            УЛСЫН ИХ ХУРАЛД НЭР ДЭВШСЭН ЭМЭГТЭЙЧҮҮДИЙН ЭЗЛЭХ ХУВЬ
    ## 956                                                                  ТАВ ХҮРТЭЛХ НАСНЫ ХҮҮХДИЙН ЭНДЭГДЛИЙН ТҮВШИН, 1000 амьд төрөлтөд ногдох, жилийн эцсийн байдлаар
    ## 957                                                                                                              1000 АМЬД ТӨРӨЛТӨД НОГДОХ НЯЛХСЫН ЭНДЭГДЛИЙН ТҮВШИН
    ## 958                                                                             УЛААН БУРХАНЫ ЭСРЭГ ВАКЦИНЖУУЛАЛТАД ХАМРАГДСАН НЭГ ХҮРТЭЛХ НАСНЫ ХҮҮХДИЙН ХУВИЙН ЖИН
    ## 959                                                                                          ЭХИЙН ЭНДЭГДЛИЙН ТҮВШИН, (100000 амьд төрөлтөд ногдох)аймаг, нийслэлээр
    ## 960                                                                                    ЭРҮҮЛ МЭНДИЙН МЭРГЭЖЛИЙН АЖИЛТНЫ ЭХ БАРЬСАН ТӨРӨЛТИЙН ХУВЬ, аймаг, нийслэлээр
    ## 961                                                                                                                 ЖИРЭМСЭН ЭМЭГТЭЙЧҮҮДИЙН ДУНД ХДХВ ӨВЧНИЙ ТАРХАЛТ
    ## 962                                                                                                        15-24 НАСНЫ ЗАЛУУЧУУДЫН ДУНДАХЬ ХДХВ-ЫН ХАЛДВАРЫН ТАРХАЛТ
    ## 963                                                                                             100000 ХҮНД НОГДОХ СҮРЬЕЭ ӨВЧНИЙ ТАРХАЛТЫН ТҮВШИН, аймаг, нийслэлээр
    ## 964                                                                                                100000 ХҮНД НОГДОХ СҮРЬЕЭГИЙН ӨВЧЛӨЛИЙН ТҮВШИН, аймаг, нийслэлээр
    ## 965                                                                                          100000 ХҮНД НОГДОХ СҮРЬЕЭГЭЭС ШАЛТГААЛСАН НАС БАРАЛТ, аймаг, нийслэлээр
    ## 966                                                   СҮРЬЕЭ ӨВЧНӨӨР ОНОШЛОГДОЖ БОГИНО ХУГАЦААНЫ ШУУД ЭМЧИЛГЭЭГЭЭР ЭДГЭРСЭН ТОХИОЛДЛЫН ХУВИЙН ЖИН, аймаг, нийслэлээр
    ## 967                                                                                                                        ОЙТ НУТГИЙН ЭЗЛЭХ ХУВЬ, аймаг, нийслэлээр
    ## 968                                                                                            ТУСГАЙ ХАМГААЛАЛТАД АВСАН ГАЗАР НУТГИЙН ЭЗЛЭХ ХУВЬ, аймаг, нийслэлээр
    ## 969                                                                                                    НЭГ ХҮНД НОГДОХ НҮҮРСХҮЧЛИЙН ДАВХАР ИСЛИЙН ЯЛГАРАЛТ, тонн/хүн
    ## 970                                                                        УЛААНБААТАР ХОТЫН АГААР ДАХЬ АЗОТЫН ДАВХАР ИСЛИЙН ӨВЛИЙН ХОНОГИЙН ДУНДАЖ АГУУЛАМЖ, мкг/м3
    ## 971                                                                                        УЛААНБААТАР ХОТЫН АГААР ДАХЬ ХҮХЭРЛЭГ ХИЙН ӨВЛИЙН ДУНДАЖ АГУУЛАМЖ, мкг/м3
    ## 972                                                                                      ХАМГААЛАЛТАД АВСАН ГОЛ МӨРНИЙ УСНЫ УРСАЦ БҮРЭЛДЭХ УНДАРГЫН ЭХИЙН ЭЗЛЭХ ХУВЬ
    ## 973                                                                                              ХАМГААЛАЛТ БАРЬЖ ТОХИЖУУЛСАН УСНЫ ЭХ ҮҮСВЭР, БУЛАГ ШАНДЫН ЭХИЙН ТОО
    ## 974                                                                                           БАТАЛГААТ УНДНЫ УСНЫ ХАНГАМЖГҮЙ ХҮН АМЫН ЭЗЛЭХ ХУВЬ, аймаг, нийслэлээр
    ## 975                                                                       САЙЖРУУЛСАН АРИУН ЦЭВРИЙН БАЙГУУЛАМЖИД ХАМРАГДААГҮЙ ХҮН АМЫН ЭЗЛЭХ ХУВЬ, аймаг, нийслэлээр
    ## 976                                                                    ИНЖЕНЕРИЙН ШУГАМ СҮЛЖЭЭТЭЙ ОРОН СУУЦАНД АМЬДАРЧ БАЙГАА ХҮН АМЫН ЭЗЛЭХ ХУВЬ, аймаг, нийслэлээр
    ## 977                                                                ХУДАЛДААНЫ ХҮЧИН ЧАДЛЫГ БИЙ БОЛГОХОД ТУСЛАХААР ҮЗҮҮЛСЭН ХӨГЖЛИЙН АЛБАН ЁСНЫ ТУСЛАМЖИЙН ЭЗЛЭХ ХУВЬ
    ## 978                                                                                    НИЙГМИЙН СУУРЬ ҮЙЛЧИЛГЭЭНД ҮЗҮҮЛСЭН ХӨГЖЛИЙН АЛБАН ЁСНЫ ТУСЛАМЖИЙН ЭЗЛЭХ ХУВЬ
    ## 979                                                                                              ДОТООДЫН НИЙТ БҮТЭЭГДЭХҮҮНД БАРАА ҮЙЛЧИЛГЭЭНИЙ ЭКСПОРТЫН ЭЗЛЭХ ХУВЬ
    ## 980                                                                                         САНХҮҮГИЙН ГҮНЗГИЙРЭЛ: ДОТООДЫН НИЙТ БҮТЭЭГДЭХҮҮН, НИЙТ МӨНГӨНИЙ ХАРЬЦАА
    ## 981                                                                                                  YНДЭСНИЙ НИЙТ ОРЛОГОД ХӨГЖЛИЙН АЛБАН ЁСНЫ ТУСЛАМЖИЙН ЭЗЛЭХ ХУВЬ
    ## 982                                                                                                   ТӨМӨР ЗАМЫН АЧАА ТЭЭВЭРЛЭЛТЭД ДАМЖИН ӨНГӨРӨХ АЧААНЫ ЭЗЛЭХ ХУВЬ
    ## 983                                                                                               ДОТООДЫН НИЙТ БҮТЭЭГДЭХҮҮНД ЗАСГИЙН ГАЗРЫН ГАДААД ӨРИЙН ЭЗЛЭХ ХУВЬ
    ## 984                                                                                                                 ЭКСПОРТОД ЗАСГИЙН ГАЗРЫН ГАДААД ӨРИЙН ЭЗЛЭХ ХУВЬ
    ## 985                                                                                                                   ЗАСГИЙН ГАЗРЫН ОРЛОГОД ГАДААД ӨРИЙН ЭЗЛЭХ ХУВЬ
    ## 986                                                                                                    ЭКСПОРТОД ЗАСГИЙН ГАЗРЫН ГАДААД ӨРИЙН ҮЙЛЧИЛГЭЭНИЙ ЭЗЛЭХ ХУВЬ
    ## 987                                                                                                      ЗАСГИЙН ГАЗРЫН ОРЛОГОД ГАДААД ӨРИЙН ҮЙЛЧИЛГЭЭНИЙ ЭЗЛЭХ ХУВЬ
    ## 988                                                                                                                        1000 ХҮНД НОГДОХ СУУРИН УТАСНЫ ЦЭГИЙН ТОО
    ## 989                                                                                                              1000 ХҮНД НОГДОХ ИНТЕРНЕТ БАЙНГЫН ХЭРЭГЛЭГЧДИЙН ТОО
    ## 990                                                                                                                 1000 ХҮНД НОГДОХ ҮҮРЭН ТЕЛЕФОН ХЭРЭГЛЭГЧДИЙН ТОО
    ## 991                                                                                                                        ХҮНИЙ ХӨГЖЛИЙН ИНДЕКС*, аймаг, нийслэлээр
    ## 992                                                                                                                       ШҮҮХИЙН ШИЙДВЭР ГҮЙЦЭТГЭЛИЙН БОДИТ БИЕЛЭЛТ
    ## 993                                                                                               ТӨЛБӨРИЙН ЧАДВАРГҮЙ ИРГЭДЭД ҮЙЛЧИЛГЭЭ ҮЗҮҮЛЖ БУЙ ӨМГӨӨЛӨГЧДИЙН ТОО
    ## 994                                                                    ТӨСӨВ, ТҮҮНИЙ ЗАРЦУУЛАЛТЫН ТАЙЛАНГ ВЭБ ХУУДСАНДАА ТОГТМОЛ БАЙРЛУУЛДАГ ТӨРИЙН БАЙГУУЛЛАГЫН ТОО
    ## 995                                                    УЛСЫН ТӨСВИЙН ТӨСЛИЙГ БОЛОВСРУУЛАХ, БАТЛАХ ҮЕД САНАЛАА АЛБАН ЁСООР ИРҮҮЛСЭН ИРГЭНИЙ НИЙГМИЙН БАЙГУУЛЛАГЫН ТОО
    ## 996                                                                                                                                АВЛИГЫН ИНДЕКС, аймаг, нийслэлээр
    ## 997                                                                                        УЛС ТӨР, ХУУЛЬ, ХЯНАЛТЫН БАЙГУУЛЛАГЫН ХҮРЭЭН ДЭХ АВЛИГЫН ТАЛААРХ ТӨСӨӨЛӨЛ
    ## 998                                                                                                    5 ХҮРТЭЛХ НАСНЫ ТУРААЛТАЙ ХҮҮХДИЙН ЭЗЛЭХ ХУВЬ, хот, хөдөөгөөр
    ## 999                                                                                                                     DIAL-1 Үйлдвэрчний эвлэлийн нягтралын түвшин
    ## 1000                                                                                                                 ЖИРЭМСЛЭХЭЭС СЭРГИЙЛЭХ АРГА ХЭРЭГСЛИЙН ХЭРЭГЛЭЭ
    ## 1001                                                                                                    5 ХҮРТЭЛХ НАСНЫ ТУРААЛТАЙ ХҮҮХДИЙН ЭЗЛЭХ ХУВЬ, насны бүлгээр
    ## 1002                                                                                                           5 ХҮРТЭЛХ НАСНЫ ТУРААЛТАЙ ХҮҮХДИЙН ЭЗЛЭХ ХУВЬ, бүсээр
    ## 1003                                                                                                       5 ХҮРТЭЛХ НАСНЫ ТУРААЛТАЙ ХҮҮХДИЙН ЭЗЛЭХ ХУВЬ, суурьшлаар
    ## 1004                                                                                       5 ХҮРТЭЛХ НАСНЫ ТУРААЛТАЙ ХҮҮХДИЙН ЭЗЛЭХ ХУВЬ, эхийн боловсролын түвшнээр
    ## 1005                                                                              5 ХҮРТЭЛХ НАСНЫ ТУРААЛТАЙ ХҮҮХДИЙН ЭЗЛЭХ ХУВЬ, аж байдлын түвшний 5 тэнцүү бүлгээр
    ## 1006                                                                                         5 ХҮРТЭЛХ НАСНЫ ӨСӨЛТИЙН ХОЦРОЛТТОЙ ХҮҮХДИЙН ЭЗЛЭХ ХУВЬ, хот, хөдөөгөөр
    ## 1007                                                                                                5 ХҮРТЭЛХ НАСНЫ ӨСӨЛТИЙН ХОЦРОЛТТОЙ ХҮҮХДИЙН ЭЗЛЭХ ХУВЬ, хүйсээр
    ## 1008                                                                                          5 ХҮРТЭЛХ НАСНЫ ӨСӨЛТИЙН ХОЦРОЛТТОЙ ХҮҮХДИЙН ЭЗЛЭХ ХУВЬ, насны бүлгээр
    ## 1009                                                                                                 5 ХҮРТЭЛХ НАСНЫ ӨСӨЛТИЙН ХОЦРОЛТТОЙ ХҮҮХДИЙН ЭЗЛЭХ ХУВЬ, бүсээр
    ## 1010                                                                                             5 ХҮРТЭЛХ НАСНЫ ӨСӨЛТИЙН ХОЦРОЛТТОЙ ХҮҮХДИЙН ЭЗЛЭХ ХУВЬ, суурьшлаар
    ## 1011                                                                             5 ХҮРТЭЛХ НАСНЫ ӨСӨЛТИЙН ХОЦРОЛТТОЙ ХҮҮХДИЙН ЭЗЛЭХ ХУВЬ, эхийн боловсролын түвшнээр
    ## 1012                                                                    5 ХҮРТЭЛХ НАСНЫ ӨСӨЛТИЙН ХОЦРОЛТТОЙ ХҮҮХДИЙН ЭЗЛЭХ ХУВЬ, аж байдлын түвшний 5 тэнцүү бүлгээр
    ## 1013                                                                                                    5 ХҮРТЭЛХ НАСНЫ ТУРАНХАЙ ХҮҮХДИЙН ЭЗЛЭХ ХУВЬ, хот, хөдөөгөөр
    ## 1014                                                                                                           5 ХҮРТЭЛХ НАСНЫ ТУРАНХАЙ ХҮҮХДИЙН ЭЗЛЭХ ХУВЬ, хүйсээр
    ## 1015                                                                                                     5 ХҮРТЭЛХ НАСНЫ ТУРАНХАЙ ХҮҮХДИЙН ЭЗЛЭХ ХУВЬ, насны бүлгээр
    ## 1016                                                                                                            5 ХҮРТЭЛХ НАСНЫ ТУРАНХАЙ ХҮҮХДИЙН ЭЗЛЭХ ХУВЬ, бүсээр
    ## 1017                                                                                                        5 ХҮРТЭЛХ НАСНЫ ТУРАНХАЙ ХҮҮХДИЙН ЭЗЛЭХ ХУВЬ, суурьшлаар
    ## 1018                                                                                       5 ХҮРТЭЛХ НАСНЫ ТУРАНХАЙ ХҮҮХДИЙН ЭЗЛЭХ ХУВЬ , эхийн боловсролын түвшнээр
    ## 1019                                                                               5 ХҮРТЭЛХ НАСНЫ ТУРАНХАЙ ХҮҮХДИЙН ЭЗЛЭХ ХУВЬ, аж байдлын түвшний 5 тэнцүү бүлгээр
    ## 1020                                                                                                            СҮМ ХИЙДИЙН ТОО, шашны төрөл, аймаг, нийслэл, жилээр
    ## 1021                                                                                                       ХУРЛЫН ЛАМ НАРЫН ТОО, шашны төрөл, аймаг, нийслэл, жилээр
    ## 1022                                                                                     ШАШНЫ СУРГУУЛЬ ДАЦАНД СУРАЛЦАГЧДЫН ТОО, шашны төрөл, аймаг, нийслэл, жилээр
    ## 1023                                                                                                     ЯДУУРЛЫН ҮНДСЭН ҮЗҮҮЛЭЛТ, бүс, суурьшил, жилээр /1995-2020/
    ## 1024                                                                                                          ЯДУУРЛЫН ҮНДСЭН ҮЗҮҮЛЭЛТ, бүс, суурьшил, жилээр /2022/
    ## 1025                                                              НЭГ ХҮНД НОГДОХ САРЫН ХЭРЭГЛЭЭ, хэрэглээний үндсэн бүлэг, ядуурлын байдал, бүс, жилээр /2003-2020/
    ## 1026                                                                                 ХҮН АМЫН АМЬЖИРГААНЫ ДООД ТҮВШИН, нэг хүнд сард ногдох, бүс, жилээр /2001-2025/
    ## 1027                                                                           НЭГ ХҮНД НОГДОХ САРЫН ХЭРЭГЛЭЭ, хэрэглээний үндсэн бүлэг, байршил, жилээр /2003-2020/
    ## 1028                                                                       НЭГ ХҮНД НОГДОХ САРЫН ХЭРЭГЛЭЭ, өрхийн тооны тэнцүү 10 бүлэг, байршил, жилээр /2003-2020/
    ## 1029                                                                                        ХҮН АМЫН ХЭРЭГЛЭЭНИЙ БҮТЭЦ, өрхийн тооны тэнцүү 5 бүлэг, байршил, жилээр
    ## 1030                                                                                 ХҮН АМЫН АМЬЖИРГААНЫ ДООД ТҮВШИН, нэг хүнд сард ногдох, бүс, жилээр /1999-2000/
    ## 1031                                                                                                     ЯДУУРЛЫН ЗУРАГЛАЛ, бүс, сум, дүүргийн түвшний үр дүн /2011/
    ## 1032                                                                                                        ЯДУУРЛЫН ҮНДСЭН ҮЗҮҮЛЭЛТ, аймаг, бүс, жилээр /2016-2020/
    ## 1033                                                                        ТЭГШ БУС БАЙДАЛ, нэг хүнд сард ногдох хэрэглээнд үндэслэн тооцсон, бүс, суурьшил, жилээр
    ## 1034                                                                                                       НИЙГМИЙН ДААТГАЛЫН САНГИЙН ОРЛОГО, аймаг, нийслэл, жилээр
    ## 1035                                                                                               НИЙГМИЙН ДААТГАЛЫН САНГИЙН ЗАРЛАГА, төрөл, аймаг, нийслэл, жилээр
    ## 1036                                                                               НИЙГМИЙН ДААТГАЛЫН САНГААС ТЭТГЭВЭР АВАГЧДЫН САРЫН ДУНДАЖ ТЭТГЭВЭР, төрөл, жилээр
    ## 1037                                                                                             НИЙГМИЙН ДААТГАЛЫН САНГААС ТЭТГЭВЭР АВАГЧИД, аймаг, нийслэл, жилээр
    ## 1038                                                                                НИЙГМИЙН ДААТГАЛЫН САНГААС ӨНДӨР НАСТНЫ ТЭТГЭВЭР АВАГЧИД, аймаг, нийслэл, жилээр
    ## 1039                                                                НИЙГМИЙН ДААТГАЛЫН САНГААС ХӨГЖЛИЙН БЭРХШЭЭЛТЭЙ ИРГЭНИЙ ТЭТГЭВЭР АВАГЧИД, аймаг, нийслэл, жилээр
    ## 1040                                                                           НИЙГМИЙН ДААТГАЛЫН САНГААС ТЭЖЭЭГЧЭЭ АЛДСАНЫ ТЭТГЭВЭР АВАГЧИД, аймаг, нийслэл, жилээр
    ## 1041                                                                                     НИЙГМИЙН ДААТГАЛЫН САНГААС ЦЭРГИЙН ТЭТГЭВЭР АВАГЧИД, аймаг, нийслэл, жилээр
    ## 1042                                                                                    НИЙГМИЙН ДААТГАЛЫН САНГААС ОЛГОСОН ТЭТГЭВРИЙН ХЭМЖЭЭ, аймаг, нийслэл, жилээр
    ## 1043                                                         НИЙГМИЙН ДААТГАЛЫН САНГААС ӨНДӨР НАСТНЫ ТЭТГЭВЭР АВАГЧДАД ЗАРЦУУЛСАН МӨНГӨН ДҮН, аймаг, нийслэл, жилээр
    ## 1044                                         НИЙГМИЙН ДААТГАЛЫН САНГААС ХӨГЖЛИЙН БЭРХШЭЭЛТЭЙ ИРГЭНИЙ ТЭТГЭВЭР АВАГЧДАД ЗАРЦУУЛСАН МӨНГӨН ДҮН, аймаг, нийслэл, жилээр
    ## 1045                                                    НИЙГМИЙН ДААТГАЛЫН САНГААС ТЭЖЭЭГЧЭЭ АЛДСАНЫ ТЭТГЭВЭР АВАГЧДАД ЗАРЦУУЛСАН МӨНГӨН ДҮН, аймаг, нийслэл, жилээр
    ## 1046                                                              НИЙГМИЙН ДААТГАЛЫН САНГААС ЦЭРГИЙН ТЭТГЭВЭР АВАГЧДАД ЗАРЦУУЛСАН МӨНГӨН ДҮН, аймаг, нийслэл, жилээр
    ## 1047                                                                                              НИЙГМИЙН ДААТГАЛЫН САНГААС ТЭТГЭМЖ АВАГЧИД, аймаг, нийслэл, жилээр
    ## 1048                                                                  НИЙГМИЙН ДААТГАЛЫН САНГААС ХӨДӨЛМӨРИЙН ЧАДВАР АЛДАЛТЫН ТЭТГЭМЖ АВАГЧИД, аймаг, нийслэл, жилээр
    ## 1049                                                                     НИЙГМИЙН ДААТГАЛЫН САНГААС ЖИРЭМСЭН БОЛОН АМАРЖСАНЫ ТЭТГЭМЖ АВАГЧИД, аймаг, нийслэл, жилээр
    ## 1050                                                                                    НИЙГМИЙН ДААТГАЛЫН САНГААС ОРШУУЛГЫН ТЭТГЭМЖ АВАГЧИД, аймаг, нийслэл, жилээр
    ## 1051                                                                                 НИЙГМИЙН ДААТГАЛЫН САНГААС АЖИЛГҮЙДЛИЙН ТЭТГЭМЖ АВАГЧИД, аймаг, нийслэл, жилээр
    ## 1052                                                         НИЙГМИЙН ДААТГАЛЫН САНГААС ЭРҮҮЛ МЭНДИЙН НӨХӨН СЭРГЭЭХ ҮЙЛЧИЛГЭЭНД ХАМРАГДАГЧИД, аймаг, нийслэл, жилээр
    ## 1053                                                                               НИЙГМИЙН ДААТГАЛЫН САНГААС ОЛГОСОН НИЙТ ТЭТГЭМЖИЙН ХЭМЖЭЭ, аймаг, нийслэл, жилээр
    ## 1054                                                   НИЙГМИЙН ДААТГАЛЫН САНГААС ОЛГОСОН ХӨДӨЛМӨРИЙН ЧАДВАРАА ТҮР АЛДСАНЫ ТЭТГЭМЖИЙН ХЭМЖЭЭ, аймаг, нийслэл, жилээр
    ## 1055                                                          НИЙГМИЙН ДААТГАЛЫН САНГААС ОЛГОСОН ЖИРЭМСНИЙ БОЛОН АМАРЖСАНЫ ТЭТГЭМЖИЙН ХЭМЖЭЭ, аймаг, нийслэл, жилээр
    ## 1056                                                                          НИЙГМИЙН ДААТГАЛЫН САНГААС ОЛГОСОН ОРШУУЛГЫН ТЭТГЭМЖИЙН ХЭМЖЭЭ, аймаг, нийслэл, жилээр
    ## 1057                                                                       НИЙГМИЙН ДААТГАЛЫН САНГААС ОЛГОСОН АЖИЛГҮЙДЛИЙН ТЭТГЭМЖИЙН ХЭМЖЭЭ, аймаг, нийслэл, жилээр
    ## 1058                                                                                                  НИЙГМИЙН ДААТГАЛЫН САНГААС ТЭТГЭМЖ АВАГЧИД, тэтгэмжийн төрлөөр
    ## 1059                                                                                  НИЙГМИЙН ДААТГАЛЫН САНГААС ОЛГОСОН ТЭТГЭМЖИЙН ХЭМЖЭЭ, тэтгэмжийн төрөл, жилээр
    ## 1060                                                                     Ядуурлын үндэсний түвшнээс доогуур амьжиргаатай хүн амын эзлэх хувь, хүйсээр, насны бүлгээр
    ## 1061                                                                                                                                     НИЙТ ГЭРЭЭНИЙ ТОО, улирлаар
    ## 1062                                                                                                         ХУВЬ ХҮНТЭЙ БАЙГУУЛСАН ДААТГАЛЫН ГЭРЭЭНИЙ ТОО, улирлаар
    ## 1063                                                                                                   ХУУЛИЙН ЭТГЭЭДТЭЙ БАЙГУУЛСАН ДААТГАЛЫН ГЭРЭЭНИЙ ТОО, улирлаар
    ## 1064                                                                                                                           ДААТГАЛЫН ХУРААМЖИЙН ОРЛОГО, улирлаар
    ## 1065                                                                                                                                ДААТГАЛЫН НӨХӨН ТӨЛБӨР, улирлаар
    ## 1066                                                                                          АЖ ҮЙЛДВЭРИЙН САЛБАРЫН ҮЙЛДВЭРЛЭГЧИЙН ҮНИЙН ИНДЕКС, дэд салбар, сараар
    ## 1067                                                                       АЖ ҮЙЛДВЭРИЙН САЛБАРЫН ҮЙЛДВЭРЛЭГЧИЙН ҮНИЙН ИНДЕКС, дэд салбар, сараар, (2016.01-2025.05)
    ## 1068                                                                ЗОЧИД БУУДАЛ, БАЙР, СУУЦААР ҮЙЛЧЛЭХ САЛБАРЫН ҮЙЛДВЭРЛЭГЧИЙН ҮНИЙН ИНДЕКС, аймаг, нийслэл, сараар
    ## 1069                                              ЗОЧИД БУУДАЛ, БАЙР, СУУЦААР ҮЙЛЧЛЭХ САЛБАРЫН ҮЙЛДВЭРЛЭГЧИЙН ҮНИЙН ИНДЕКС, аймаг, нийслэл, сараар (2024.04-2025.03)
    ## 1070                                              ЗОЧИД БУУДАЛ, БАЙР, СУУЦААР ҮЙЛЧЛЭХ САЛБАРЫН ҮЙЛДВЭРЛЭГЧИЙН ҮНИЙН ИНДЕКС, аймаг, нийслэл, улирал ( 2016.I-2024.I )
    ## 1071                                                                                     НИЙТИЙН ХООЛНЫ САЛБАРЫН ҮЙЛДВЭРЛЭГЧИЙН ҮНИЙН ИНДЕКС, аймаг, нийслэл, сараар
    ## 1072                                                                   НИЙТИЙН ХООЛНЫ САЛБАРЫН ҮЙЛДВЭРЛЭГЧИЙН ҮНИЙН ИНДЕКС, аймаг, нийслэл, сараар (2024.04-2025.04)
    ## 1073                                                                   НИЙТИЙН ХООЛНЫ САЛБАРЫН ҮЙЛДВЭРЛЭГЧИЙН ҮНИЙН ИНДЕКС, аймаг, нийслэл, улирал ( 2016.I-2024.I )
    ## 1074                                                                                    МЭДЭЭЛЭЛ, ХОЛБООНЫ САЛБАРЫН ҮЙЛДВЭРЛЭГЧИЙН ҮНИЙН ИНДЕКС, дэд салбар, сараар,
    ## 1075                                                                   МЭДЭЭЛЭЛ, ХОЛБООНЫ САЛБАРЫН ҮЙЛДВЭРЛЭГЧИЙН ҮНИЙН ИНДЕКС, дэд салбар, сараар (2024.04-2024.12)
    ## 1076                                                                   МЭДЭЭЛЭЛ, ХОЛБООНЫ САЛБАРЫН ҮЙЛДВЭРЛЭГЧИЙН ҮНИЙН ИНДЕКС, дэд салбар, улирал ( 2016.I-2024.I )
    ## 1077                                                                                               ТЭЭВРИЙН САЛБАРЫН ҮЙЛДВЭРЛЭГЧИЙН ҮНИЙН ИНДЕКС, дэд салбар, сараар
    ## 1078                                                                            ТЭЭВРИЙН САЛБАРЫН ҮЙЛДВЭРЛЭГЧИЙН ҮНИЙН ИНДЕКС, дэд салбар, сараар, (2024.04-2024.12)
    ## 1079                                                                              ТЭЭВРИЙН САЛБАРЫН ҮЙЛДВЭРЛЭГЧИЙН ҮНИЙН ИНДЕКС, дэд салбар, улирал (2016.I-2024.I )
    ## 1080                                                                                                                          ЭХИЙН ЭНДЭГДЭЛ, бүс, аймаг, нийслэлээр
    ## 1081                                                                                                                          ЭХИЙН ЭНДЭГДЭЛ, аймаг, нийслэл, сараар
    ## 1082                                                                                                 ЭМНЭЛЭГТ ХЭВТЭЖ ЭМЧЛҮҮЛСЭН ӨВЧТӨНИЙ ТОО, аймаг, нийслэл, жилээр
    ## 1083                                                                                                            ЭМНЭЛЭГТ ХЭВТЭН ЭМЧЛҮҮЛЭГЧИД, аймаг, нийслэл, сараар
    ## 1084                                                             ДОТООДЫН БАРИЛГЫН БАЙГУУЛЛАГЫН ГҮЙЦЭТГЭСЭН БАРИЛГА УГСРАЛТ, ИХ ЗАСВАРЫН АЖИЛ, сум, дүүрэг, улирлаар
    ## 1085                                                               ДОТООДЫН БАРИЛГЫН БАЙГУУЛЛАГЫН ГҮЙЦЭТГЭСЭН БАРИЛГА УГСРАЛТ, ИХ ЗАСВАРЫН АЖИЛ, сум, дүүрэг, жилээр
    ## 1086                                                                                                                  ГЭРЧИЛГЭЭ ОЛГОСОН АШИГТАЙ ЗАГВАР, хагас жилээр
    ## 1087                                                                                                                        ГЭРЧИЛГЭЭ ОЛГОСОН АШИГТАЙ ЗАГВАР, жилээр
    ## 1088                                                                                                                                       ЗОХИОГЧИЙН ЭРХ, хагас жил
    ## 1089                                                                                                               БҮТЭЭГДЭХҮҮНИЙ ЗАГВАРЫН ПАТЕНТЫН МЭДҮҮЛЭГ, жилээр
    ## 1090                                                                                                         БҮТЭЭГДЭХҮҮНИЙ ЗАГВАРЫН ПАТЕНТЫН МЭДҮҮЛЭГ, хагас жилээр
    ## 1091                                                                                                               БҮТЭЭГДЭХҮҮНИЙ ЗАГВАРЫН ПАТЕНТЫН МЭДҮҮЛЭГ, жилээр
    ## 1092                                                                                                                  ШИНЭ БҮТЭЭЛИЙН ПАТЕНТЫН МЭДҮҮЛЭГ, хагас жилээр
    ## 1093                                                                                                                        ШИНЭ БҮТЭЭЛИЙН ПАТЕНТЫН МЭДҮҮЛЭГ, жилээр
    ## 1094                                                                                                                            ХҮЧИНТЭЙ БАЙГАА ПАТЕНТ, хагас жилээр
    ## 1095                                                                                                                                  ХҮЧИНТЭЙ БАЙГАА ПАТЕНТ, жилээр
    ## 1096                                                                                                                          ХҮЧИНТЭЙ БАЙГАА БАРААНЫ ТЭМДЭГ, жилээр
    ## 1097                                                                                                            ЗОХИОГЧИЙН ЭРХЭЭР ХАМГААЛАГДСАН БҮТЭЭЛ, хагас жилээр
    ## 1098                                                                                                                  ЗОХИОГЧИЙН ЭРХЭЭР ХАМГААЛАГДСАН БҮТЭЭЛ, жилээр
    ## 1099                                                                                                                         БАРААНЫ ТЭМДГИЙН МЭДҮҮЛЭГ, хагас жилээр
    ## 1100                                                                                                                               БАРААНЫ ТЭМДГИЙН МЭДҮҮЛЭГ, жилээр
    ## 1101                                                                                                                         АШИГТАЙ ЗАГВАРЫН МЭДҮҮЛЭГ, хагас жилээр
    ## 1102                                                                                                                               АШИГТАЙ ЗАГВАРЫН МЭДҮҮЛЭГ, жилээр
    ## 1103                                                                                                                               НИЙТ ОЛГОСОН ПАТЕНТ, хагас жилээр
    ## 1104                                                                                                                                     НИЙТ ОЛГОСОН ПАТЕНТ, жилээр
    ## 1105                                                                                                                    ХҮЧИНТЭЙ БАЙГАА БАРААНЫ ТЭМДЭГ, хагас жилээр
    ## 1106                                                                                                                          ХҮЧИНТЭЙ БАЙГАА БАРААНЫ ТЭМДЭГ, жилээр
    ## 1107                                                                                                          ЭРХИЙН ХАМГААЛАЛТ ОЛГОСОН БАРААНЫ ТЭМДЭГ, хагас жилээр
    ## 1108                                                                                                                ЭРХИЙН ХАМГААЛАЛТ ОЛГОСОН БАРААНЫ ТЭМДЭГ, жилээр
    ## 1109                                                                                                                    ХҮЧИНТЭЙ БАЙГАА АШИГТАЙ ЗАГВАР, хагас жилээр
    ## 1110                                                                                                                          ХҮЧИНТЭЙ БАЙГАА АШИГТАЙ ЗАГВАР, жилээр
    ## 1111                                                                                ХАРИЛЦАА ХОЛБООНЫ ҮЙЛЧИЛГЭЭНИЙ ҮНДСЭН ҮЗҮҮЛЭЛТ, бүс, аймаг, нийслэлээр, улирлаар
    ## 1112                                                                                  ХАРИЛЦАА ХОЛБООНЫ ҮЙЛЧИЛГЭЭНИЙ ҮНДСЭН ҮЗҮҮЛЭЛТ, бүс, аймаг, нийслэлээр, жилээр
    ## 1113                                                                                   КАБЕЛИЙН ТЕЛЕВИЗ ХЭРЭГЛЭГЧДИЙН ТОО, төрлөөр, бүс, аймаг, нийслэлээр, улирлаар
    ## 1114                                                                                     КАБЕЛИЙН ТЕЛЕВИЗ ХЭРЭГЛЭГЧДИЙН ТОО, төрлөөр, бүс, аймаг, нийслэлээр, жилээр
    ## 1115                                                                                         ИНТЕРНЭТ ХЭРЭГЛЭГЧ БА КОМПЬЮТЕРЫН ТОО, бүс, аймаг, нийслэлээр, улирлаар
    ## 1116                                                                                           ИНТЕРНЭТ ХЭРЭГЛЭГЧ БА КОМПЬЮТЕРЫН ТОО, бүс, аймаг, нийслэлээр, жилээр
    ## 1117                                                                                                  ШУУДАНГИЙН ҮЙЛЧИЛГЭЭНИЙ ҮЗҮҮЛЭЛТ, шуудангийн төрлөөр, улирлаар
    ## 1118                                                                                                    ШУУДАНГИЙН ҮЙЛЧИЛГЭЭНИЙ ҮЗҮҮЛЭЛТ, шуудангийн төрлөөр, жилээр
    ## 1119                                                          МЭДЭЭЛЭЛ, ХАРИЛЦАА ХОЛБООНЫ САЛБАРЫН ОРЛОГО, үйл ажиллагааны төрлөөр, бүс, аймаг, нийслэлээр, улирлаар
    ## 1120                                                            МЭДЭЭЛЭЛ, ХАРИЛЦАА ХОЛБООНЫ САЛБАРЫН ОРЛОГО, үйл ажиллагааны төрлөөр, бүс, аймаг, нийслэлээр, жилээр
    ## 1121                                                                                                            УЛСЫН ХИЛЭЭР НЭВТЭРСЭН ЗОРЧИГЧДЫН ТОО, боомт, сараар
    ## 1122                                                                                                          УЛСЫН ХИЛЭЭР НЭВТЭРСЭН ЗОРЧИГЧДЫН ТОО, боомт, улирлаар
    ## 1123                                                                                                            УЛСЫН ХИЛЭЭР НЭВТЭРСЭН ЗОРЧИГЧДЫН ТОО, боомт, жилээр
    ## 1124                                                                                                     УЛСЫН ХИЛЭЭР НЭВТЭРСЭН ГАДААДЫН ЗОРЧИГЧДЫН ТОО, улс, сараар
    ## 1125                                                                                                   УЛСЫН ХИЛЭЭР НЭВТЭРСЭН ГАДААДЫН ЗОРЧИГЧДЫН ТОО, улс, улирлаар
    ## 1126                                                                                                     УЛСЫН ХИЛЭЭР НЭВТЭРСЭН ГАДААДЫН ЗОРЧИГЧДЫН ТОО, улс, жилээр
    ## 1127                                                                                                УЛСЫН ХИЛЭЭР ОРСОН ЗОРЧИГЧДЫН ТОО, аяллын зорилго, боомт, сараар
    ## 1128                                                                                              УЛСЫН ХИЛЭЭР ОРСОН ЗОРЧИГЧДЫН ТОО, боомт, аяллын зорилго, улирлаар
    ## 1129                                                                                                УЛСЫН ХИЛЭЭР ОРСОН ЗОРЧИГЧДЫН ТОО, боомт, аяллын зорилго, жилээр
    ## 1130                                                                                                                    УЛСЫН ХИЛЭЭР ОРСОН ЖУУЛЧДЫН ТОО, улс, сараар
    ## 1131                                                                                                                  УЛСЫН ХИЛЭЭР ОРСОН ЖУУЛЧДЫН ТОО, улс, улирлаар
    ## 1132                                                                                                                    УЛСЫН ХИЛЭЭР ОРСОН ЖУУЛЧДЫН ТОО, улс, жилээр
    ## 1133                                                                                             ГАДААДАД ЗОРЧСОН МОНГОЛ ИРГЭДИЙН ТОО, аяллын зорилго, боомт, сараар
    ## 1134                                                                                             ГАДААДАД ЗОРЧСОН МОНГОЛ ИРГЭДИЙН ТОО, боомт, аяллын зорилго, жилээр
    ## 1135                                                                                   НИЙТИЙН ХООЛНЫ САЛБАРЫН ОРЛОГО, бүс, аймаг, нийслэлээр, сараар, өссөн дүнгээр
    ## 1136                                                                                 НИЙТИЙН ХООЛНЫ САЛБАРЫН ОРЛОГО, бүс, аймаг, нийслэлээр, улирлаар, өссөн дүнгээр
    ## 1137                                                                                    ЗОЧИД БУУДЛЫН САЛБАРЫН ОРЛОГО, бүс, аймаг, нийслэлээр, сараар, өссөн дүнгээр
    ## 1138                                                                                  ЗОЧИД БУУДЛЫН САЛБАРЫН ОРЛОГО, бүс, аймаг, нийслэлээр, улирлаар, өссөн дүнгээр
    ## 1139                                                                                                  АГААРЫН ТЭЭВРИЙН ЗОРЧИГЧ, чиглэл тус бүрээр, улсын дүн, сараар
    ## 1140                                                                                                АГААРЫН ТЭЭВРИЙН ЗОРЧИГЧ, чиглэл тус бүрээр, улсын дүн, улирлаар
    ## 1141                                                                                                  АГААРЫН ТЭЭВРИЙН ЗОРЧИГЧ, чиглэл тус бүрээр, улсын дүн, жилээр
    ## 1142                                                                                                             АГААРЫН ТЭЭВРИЙН ҮНДСЭН ҮЗҮҮЛЭЛТ, улсын дүн, сараар
    ## 1143                                                                                                           АГААРЫН ТЭЭВРИЙН ҮНДСЭН ҮЗҮҮЛЭЛТ, улсын дүн, улирлаар
    ## 1144                                                                                                             АГААРЫН ТЭЭВРИЙН ҮНДСЭН ҮЗҮҮЛЭЛТ, улсын дүн, жилээр
    ## 1145                                                                                                        АВТО ЗАМЫН ТЭЭВРИЙН ҮНДСЭН ҮЗҮҮЛЭЛТ, улсын дүн, улирлаар
    ## 1146                                                                                                                     АВТО ЗАМЫН ТЭЭВРИЙН ҮНДСЭН ҮЗҮҮЛЭЛТ, жилээр
    ## 1147                                                                                                         ТӨМӨР ЗАМЫН ТЭЭВРИЙН ҮНДСЭН ҮЗҮҮЛЭЛТ, улсын дүн, сараар
    ## 1148                                                                                                       ТӨМӨР ЗАМЫН ТЭЭВРИЙН ҮНДСЭН ҮЗҮҮЛЭЛТ, улсын дүн, улирлаар
    ## 1149                                                                                                         ТӨМӨР ЗАМЫН ТЭЭВРИЙН ҮНДСЭН ҮЗҮҮЛЭЛТ, улсын дүн, жилээр
    ## 1150                                                                                          ХӨДӨЛМӨРИЙН ГЭРЭЭГЭЭР ГАДААД УЛСАД ЗУУЧЛАГДСАН ИРГЭД, улс орон, жилээр
    ## 1151                                                                                        ХӨДӨЛМӨРИЙН ГЭРЭЭГЭЭР ГАДААД УЛСАД ЗУУЧЛАГДСАН ИРГЭД, улс орон, улирлаар
    ## 1152                                                                             15 БА ТҮҮНЭЭС ДЭЭШ НАСНЫ ХҮН АМЫН ХӨДӨЛМӨР ЭРХЛЭЛТИЙН БАЙДАЛ, улсын дүнгээр, жилээр
    ## 1153                                                                           15 БА ТҮҮНЭЭС ДЭЭШ НАСНЫ ХҮН АМЫН ХӨДӨЛМӨР ЭРХЛЭЛТИЙН БАЙДАЛ, улсын дүнгээр, улирлаар
    ## 1154                                                                                            ХӨДӨЛМӨР ЭРХЛЭЛТИЙН ТҮВШИН, насны бүлэг, хүйс, аймаг, нийслэл,жилээр
    ## 1155                                                                                         ХӨДӨЛМӨР ЭРХЛЭЛТИЙН ТҮВШИН, насны бүлэг, хүйс, аймаг, нийслэл, улирлаар
    ## 1156                                                                АЖИЛЛАГЧИД, эдийн засгийн үйл ажиллагааны салбар, хүйс, насны бүлэг, бүс, аймаг, нийслэл, жилээр
    ## 1157                                                              АЖИЛЛАГЧИД, эдийн засгийн үйл ажиллагааны салбар, хүйс, насны бүлэг, бүс, аймаг, нийслэл, улирлаар
    ## 1158                                                                             АЖИЛЛАГЧИД, ажил мэргэжлийн ангилал, хүйс, насны бүлэг, бүс, аймаг, нийслэл, жилээр
    ## 1159                                                                           АЖИЛЛАГЧИД, ажил мэргэжлийн ангилал, хүйс, насны бүлэг, бүс, аймаг, нийслэл, улирлаар
    ## 1160                                                                 АЖИЛЛАГЧИД, хөдөлмөр эрхлэлтийн статусаар, насны бүлэг, бүс, аймаг, нийслэл, жилээр /1985-2018/
    ## 1161                                                               АЖИЛЛАГЧИД, хөдөлмөр эрхлэлтийн статусаар, насны бүлэг, бүс, аймаг, нийслэл, улирлаар /2007-2018/
    ## 1162                                                      АЖИЛЛАГЧИД, хөдөлмөр эрхлэлтийн статусаар, хүйс, насны бүлэг, бүс, аймаг, нийслэл, жилээр, 2019 оноос хойш
    ## 1163                                                     АЖИЛЛАГЧИД, хөдөлмөр эрхлэлтийн статус, хүйс, насны бүлэг, бүс, аймаг, нийслэлээр улирлаар, 2019 оноос хойш
    ## 1164                                                                                                        ОСОЛДОГЧИД, эдийн засгийн үйл ажиллагааны салбар, жилээр
    ## 1165                                                                                          ОСОЛДОГЧИД, эдийн засгийн үйл ажиллагааны салбар, улирлаар /2017-2023/
    ## 1166                                                                                        ОСОЛДОГЧИД, эдийн засгийн үйл ажиллагааны салбар, ҮОХХ-ын хэлбэр, жилээр
    ## 1167                                                                          ОСОЛДОГЧИД, эдийн засгийн үйл ажиллагааны салбар, ҮОХХ-ын хэлбэр, улирлаар /2017-2023/
    ## 1168                                                                                 АЖИЛЛАХ ХҮЧНИЙ ОРОЛЦООНЫ ТҮВШИН, хүйс, насны бүлэг, бүс, аймаг, нийслэл, жилээр
    ## 1169                                                                                    АЖИЛЛАХ ХҮЧНИЙ ОРОЛЦООНЫ ТҮВШИН, хүйс, насны бүлэг, аймаг, нийслэл, улирлаар
    ## 1170                                                                                                          АЖИЛЛАХ ХҮЧ, хүйс, насны бүлэг, аймаг, нийслэл, жилээр
    ## 1171                                                                                                        АЖИЛЛАХ ХҮЧ, хүйс, насны бүлэг, аймаг, нийслэл, улирлаар
    ## 1172                                                                             ХӨДӨЛМӨРИЙН ДУТУУ АШИГЛАЛТЫН ТҮВШИН, хүйс, насны бүлэг, бүс, аймаг, нийслэл, жилээр
    ## 1173                                                                           ХӨДӨЛМӨРИЙН ДУТУУ АШИГЛАЛТЫН ТҮВШИН, хүйс, насны бүлэг, бүс, аймаг, нийслэл, улирлаар
    ## 1174                                                                                           ХӨДӨЛМӨРИЙН ДУТУУ АШИГЛАЛТ, хүйс, насны бүлэг, аймаг, нийслэл, жилээр
    ## 1175                                                                                         ХӨДӨЛМӨРИЙН ДУТУУ АШИГЛАЛТ, хүйс, насны бүлэг, аймаг, нийслэл, улирлаар
    ## 1176                                                                                                  ҮЙЛДВЭРЛЭЛИЙН ОСОЛ, ХУРЦ ХОРДЛОГО, бүс, аймаг, нийслэл, жилээр
    ## 1177                                                                                    ҮЙЛДВЭРЛЭЛИЙН ОСОЛ, ХУРЦ ХОРДЛОГО, бүс, аймаг, нийслэл, улирлаар /2016-2023/
    ## 1178                                                                     АЖИЛЛАХ ХҮЧНЭЭС ГАДУУРХ ХҮН АМ, шалтгаанаар, хүйс, насны бүлэг, бүс, аймаг, нийслэл, жилээр
    ## 1179                                                                   АЖИЛЛАХ ХҮЧНЭЭС ГАДУУРХ ХҮН АМ, шалтгаанаар, хүйс, насны бүлэг, бүс, аймаг, нийслэл, улирлаар
    ## 1180                                                                                             АЖИЛГҮЙ ХҮН, шалтгаанаар, хүйс, насны бүлэг, аймаг, нийслэл, жилээр
    ## 1181                                                                                           АЖИЛГҮЙ ХҮН, шалтгаанаар, хүйс, насны бүлэг, аймаг, нийслэл, улирлаар
    ## 1182                                                                                                      АЖИЛЛАГЧИД, цалин хөлсний бүлэг, дүнд эзлэх хувь, улирлаар
    ## 1183                                                                                                    АЖИЛЛАГЧИД, цалин хөлсний бүлгээр, дүнд эзлэх хувиар, жилээр
    ## 1184                                                                                       АЖИЛЛАГЧДЫН САРЫН ДУНДАЖ НЭРЛЭСЭН ЦАЛИН, хариуцлагын хэлбэр, хүйс, жилээр
    ## 1185                                                                                     АЖИЛЛАГЧДЫН САРЫН ДУНДАЖ НЭРЛЭСЭН ЦАЛИН, хариуцлагын хэлбэр, хүйс, улирлаар
    ## 1186                                                                                                     АЖИЛЛАГЧДЫН САРЫН ДУНДАЖ ЦАЛИН, өмчийн хэлбэр, хүйс, жилээр
    ## 1187                                                                                                   АЖИЛЛАГЧДЫН САРЫН ДУНДАЖ ЦАЛИН, өмчийн хэлбэр, хүйс, улирлаар
    ## 1188                                                                                АЖИЛЛАГЧДЫН САРЫН ДУНДАЖ НЭРЛЭСЭН ЦАЛИН, ажиллагчдын тооны бүлгээр, хүйс, жилээр
    ## 1189                                                           АЖИЛЛАГЧДЫН САРЫН ДУНДАЖ НЭРЛЭСЭН ЦАЛИН, ажиллагчдын тооны бүлэг, хүйс, бүс, аймаг, нийслэл, улирлаар
    ## 1190                                                               АЖИЛЛАГЧДЫН САРЫН ДУНДАЖ НЭРЛЭСЭН ЦАЛИН, эдийн засгийн үйл ажиллагааны салбарын ангиллаар, жилээр
    ## 1191                                                               АЖИЛЛАГЧДЫН САРЫН ДУНДАЖ НЭРЛЭСЭН ЦАЛИН, эдийн засгийн үйл ажиллагааны салбарын ангилал, улирлаар
    ## 1192                                                                                  АЖИЛЛАГЧДЫН САРЫН ДУНДАЖ НЭРЛЭСЭН ЦАЛИН, ажил мэргэжлийн ангилал, хүйс, жилээр
    ## 1193                                                                                АЖИЛЛАГЧДЫН САРЫН ДУНДАЖ НЭРЛЭСЭН ЦАЛИН, ажил мэргэжлийн ангилал, хүйс, улирлаар
    ## 1194                                                                                        АЖИЛЛАГЧДЫН САРЫН ДУНДАЖ НЭРЛЭСЭН ЦАЛИН,бүс,аймаг, нийслэл, хүйс, жилээр
    ## 1195                                                                                    АЖИЛЛАГЧДЫН САРЫН ДУНДАЖ НЭРЛЭСЭН ЦАЛИН, хүйс, бүс, аймаг, нийслэл, улирлаар
    ## 1196                                                                                                                                  АЖИЛЛАГЧДЫН ГОЛЧ ЦАЛИН, жилээр
    ## 1197                                                                                                     АЖИЛЛАГЧДЫН ГОЛЧ ЦАЛИН, хүйс, бүс, аймаг, нийслэл, улирлаар
    ## 1198                                                                               БОДИТ ЦАЛИНГИЙН ИНДЕКС (2015=100), эдийн засгийн үйл ажиллагааны салбар, улирлаар
    ## 1199                                                                              БОДИТ ЦАЛИНГИЙН ИНДЕКС (2015=100), эдийн засгийн үйл ажиллагааны салбараар, жилээр
    ## 1200                                                                                          ГЭМТ ХЭРГИЙН УЛМААС УЧИРСАН ХОХИРОЛ, НӨХӨН ТӨЛҮҮЛЭЛТИЙН ХЭМЖЭЭ, жилээр
    ## 1201                                                                          ГЭМТ ХЭРГИЙН УЛМААС УЧИРСАН ХОХИРОЛ, НӨХӨН ТӨЛҮҮЛЭЛТИЙН ХЭМЖЭЭ, сараар (өссөн дүнгээр)
    ## 1202                                                                                   АВЛИГАТАЙ ТЭМЦЭХ ГАЗАРТ БҮРТГЭГДСЭН ГЭМТ ХЭРГИЙН ТОО, хэргийн ангилал, жилээр
    ## 1203                                                                   АВЛИГАТАЙ ТЭМЦЭХ ГАЗАРТ БҮРТГЭГДСЭН ГЭМТ ХЭРГИЙН ТОО, хэргийн ангилал, сараар (өссөн дүнгээр)
    ## 1204                                                           БҮРТГЭГДСЭН ГЭМТ ХЭРЭГТ ХОЛБОГДСОН НИЙТ ЯЛЛАГДАГЧДЫН ТОО, хүйс, насны ангилал, аймаг, нийслэл, жилээр
    ## 1205                                                          БҮРТГЭГДСЭН ГЭМТ ХЭРЭГТ ХОЛБОГДСОН НИЙТ ЯЛЛАГДАГЧДЫН ТОО, хүйс, аймаг, нийслэл, сараар (өссөн дүнгээр)
    ## 1206                                                                                                           БҮРТГЭГДСЭН ГЭМТ ХЭРГИЙН ТОО, хэргийн ангилал, жилээр
    ## 1207                                                                                           БҮРТГЭГДСЭН ГЭМТ ХЭРГИЙН ТОО, хэргийн ангилал, сараар (өссөн дүнгээр)
    ## 1208                                                                                                            БҮРТГЭГДСЭН ГЭМТ ХЭРГИЙН ТОО, аймаг, нийслэл, жилээр
    ## 1209                                                                                            БҮРТГЭГДСЭН ГЭМТ ХЭРГИЙН ТОО, аймаг, нийслэл, сараар (өссөн дүнгээр)
    ## 1210                                                                                                                 БҮРТГЭГДСЭН ГЭМТ ХЭРЭГ, хэргийн ангилал, жилээр
    ## 1211                                                                                                                 БYРТГЭГДСЭН ГЭМТ ХЭРЭГ, хэргийн ангилал, сараар
    ## 1212                                                                                                               НИЙГМИЙН ДААТГАЛЫН САНГИЙН ЗАРЛАГА, төрөл, жилээр
    ## 1213                                                                                                      НИЙГМИЙН ДААТГАЛЫН САНГИЙН ЗАРЛАГА, төрөл, сар (өссөн дүн)
    ## 1214                                                                                      НИЙГМИЙН ДААТГАЛЫН САНГААС ТЭТГЭВЭР АВАГЧДЫН ТОО, төрлөөр, сар (өссөн дүн)
    ## 1215                                                                                                        НИЙГМИЙН ДААТГАЛЫН САНГААС ТЭТГЭВЭР АВАГЧДЫН ТОО, жилээр
    ## 1216                                                                                           НИЙГМИЙН ХАЛАМЖИЙН ҮЙЛЧИЛГЭЭНД ХАМРАГДАГЧИД, төрлөөр, сар (өссөн дүн)
    ## 1217                                                                                                    НИЙГМИЙН ХАЛАМЖИЙН ҮЙЛЧИЛГЭЭНД ХАМРАГДАГЧИД, төрлөөр, жилээр
    ## 1218                                                                                                                НИЙГМИЙН ДААТГАЛЫН САНГИЙН ОРЛОГО, төрөл, жилээр
    ## 1219                                                                                                    НИЙГМИЙН ДААТГАЛЫН САНГИЙН ОРЛОГО, төрөл, сараар (өссөн дүн)
    ## 1220                                                                                                     НИЙГМИЙН ДААТГАЛД ДААТГУУЛАГЧДЫН ТОО, төрөл, сар(өссөн дүн)
    ## 1221                                                                                                  НИЙГМИЙН ДААТГАЛД ХАМРАГДСАН ДААТГУУЛАГЧДЫН ТОО, төрөл, жилээр
    ## 1222                                     НИЙГМИЙН ХАЛАМЖИЙН ҮЙЛЧИЛГЭЭНД ОЛГОСОН ТЭТГЭВЭР, ТЭТГЭМЖ, ТУСЛАМЖ, ҮЙЛЧИЛГЭЭ, ХӨНГӨЛӨЛТИЙН ХЭМЖЭЭ, төрлөөр, сар (өссөн дүн)
    ## 1223                                                НИЙГМИЙН ХАЛАМЖИЙН ҮЙЛЧИЛГЭЭНД ОЛГОСОН ТЭТГЭВЭР, ТЭТГЭМЖ, ТУСЛАМЖ, ҮЙЛЧИЛГЭЭ, ХӨНГӨЛӨЛТИЙН ХЭМЖЭЭ, төрөл, жилээр
    ## 1224                                                                                  НИЙГМИЙН ДААТГАЛЫН САНГААС ОЛГОСОН ТЭТГЭВРИЙН ХЭМЖЭЭ, төрлөөр, сар (өссөн дүн)
    ## 1225                                                                                             НИЙГМИЙН ДААТГАЛЫН САНГААС ОЛГОСОН ТЭТГЭВРИЙН ХЭМЖЭЭ, төрөл, жилээр
    ##        strt_prd    end_prd
    ## 1          <NA>       <NA>
    ## 2    2025-11-17 2024-01-02
    ## 3      2015=100   2023=100
    ## 4      2015=100   2023=100
    ## 5      2015=100   2023=100
    ## 6      2015=100   2023=100
    ## 7    2025-11-17 2021-01-06
    ## 8          2024       1991
    ## 9      2015=100   2023=100
    ## 10     2015=100   2023=100
    ## 11     2015=100   2023=100
    ## 12     2015=100   2023=100
    ## 13     2015=100   2023=100
    ## 14     2015=100   2023=100
    ## 15     2015=100   2023=100
    ## 16     2015=100   2023=100
    ## 17     2015=100   2023=100
    ## 18     2015=100   2023=100
    ## 19     2015=100   2023=100
    ## 20         <NA>       <NA>
    ## 21         2024       1991
    ## 22         <NA>       <NA>
    ## 23         2024       2004
    ## 24         2023       2023
    ## 25         2024       1997
    ## 26         2024       2003
    ## 27         2024       2000
    ## 28         2024       1999
    ## 29         2024       2003
    ## 30         <NA>       <NA>
    ## 31         2018       2011
    ## 32         <NA>       <NA>
    ## 33         2020       1990
    ## 34         2024       2003
    ## 35         <NA>       <NA>
    ## 36         2024       1999
    ## 37         <NA>       <NA>
    ## 38         <NA>       <NA>
    ## 39         <NA>       <NA>
    ## 40         <NA>       <NA>
    ## 41         2023       2021
    ## 42         2023       2021
    ## 43         2023       2020
    ## 44         2023       2021
    ## 45         2023       2019
    ## 46         2023       2019
    ## 47         2023       2019
    ## 48         2023       2019
    ## 49         2023       2015
    ## 50         2023       2015
    ## 51         2023       2015
    ## 52         2023       2005
    ## 53         2024       2015
    ## 54         2023       2015
    ## 55         2023       2015
    ## 56         2023       2015
    ## 57         2023       2015
    ## 58         2023       2015
    ## 59         <NA>       <NA>
    ## 60         <NA>       <NA>
    ## 61         <NA>       <NA>
    ## 62         2024       1924
    ## 63         <NA>       <NA>
    ## 64         <NA>       <NA>
    ## 65         2024       1995
    ## 66         <NA>       <NA>
    ## 67         2024       1995
    ## 68         2024       2005
    ## 69         <NA>       <NA>
    ## 70         2024       1995
    ## 71         <NA>       <NA>
    ## 72         2024       1995
    ## 73         2024       2005
    ## 74         <NA>       <NA>
    ## 75         <NA>       <NA>
    ## 76         <NA>       <NA>
    ## 77         <NA>       <NA>
    ## 78         <NA>       <NA>
    ## 79         2024       1921
    ## 80         2024       2007
    ## 81         <NA>       <NA>
    ## 82         2024       1991
    ## 83         2024       2004
    ## 84         <NA>       <NA>
    ## 85         2024       1991
    ## 86         2024       2004
    ## 87         <NA>       <NA>
    ## 88         2024       1990
    ## 89         2024       1990
    ## 90         2024       1990
    ## 91         <NA>       <NA>
    ## 92         <NA>       <NA>
    ## 93         <NA>       <NA>
    ## 94         <NA>       <NA>
    ## 95         2024       1989
    ## 96         2024       1989
    ## 97         2024       1990
    ## 98         2024       2007
    ## 99         2024       2011
    ## 100        2024       2011
    ## 101        2024       2010
    ## 102        <NA>       <NA>
    ## 103        2024       2011
    ## 104        <NA>       <NA>
    ## 105        2024       2010
    ## 106        <NA>       <NA>
    ## 107        2024       2011
    ## 108        <NA>       <NA>
    ## 109        <NA>       <NA>
    ## 110        <NA>       <NA>
    ## 111        <NA>       <NA>
    ## 112        <NA>       <NA>
    ## 113        <NA>       <NA>
    ## 114        2024       2000
    ## 115        2024       2000
    ## 116        2024       2001
    ## 117        2024       2010
    ## 118        <NA>       <NA>
    ## 119        2024       2004
    ## 120        <NA>       <NA>
    ## 121        <NA>       <NA>
    ## 122        2024       2010
    ## 123        2024       2010
    ## 124        <NA>       <NA>
    ## 125        <NA>       <NA>
    ## 126        <NA>       <NA>
    ## 127        <NA>       <NA>
    ## 128        <NA>       <NA>
    ## 129        <NA>       <NA>
    ## 130        2024       1990
    ## 131        <NA>       <NA>
    ## 132        2023       2015
    ## 133        2024       1990
    ## 134        2024       2000
    ## 135      2025-3     2005-1
    ## 136    2025-III     2000-I
    ## 137        2024       2000
    ## 138        2024       2010
    ## 139        2024       2001
    ## 140        2024       2000
    ## 141        2024       1990
    ## 142        2024       1990
    ## 143        2024       2000
    ## 144        2024       1990
    ## 145        2024       2010
    ## 146        2024       2002
    ## 147        2024       2002
    ## 148    2025-III     2000-I
    ## 149      2025-3     2019-1
    ## 150      2025-3     2005-1
    ## 151        2019       2010
    ## 152        2019       2010
    ## 153        2019       2010
    ## 154        2019       2010
    ## 155        2024       1990
    ## 156        <NA>       <NA>
    ## 157        2024       1995
    ## 158        2024       1980
    ## 159        2024       1980
    ## 160        2024       1980
    ## 161        2024       1989
    ## 162        2024       2010
    ## 163        <NA>       <NA>
    ## 164        2024       2015
    ## 165        2024       1990
    ## 166        2024       2000
    ## 167        <NA>       <NA>
    ## 168        <NA>       <NA>
    ## 169        2024       2010
    ## 170        2024       2010
    ## 171        <NA>       <NA>
    ## 172        2024       2010
    ## 173        2024       2010
    ## 174        <NA>       <NA>
    ## 175        <NA>       <NA>
    ## 176        <NA>       <NA>
    ## 177        2024       2010
    ## 178        2024       2010
    ## 179        2024       2010
    ## 180        <NA>       <NA>
    ## 181        <NA>       <NA>
    ## 182        2024       2000
    ## 183        <NA>       <NA>
    ## 184        <NA>       <NA>
    ## 185        <NA>       <NA>
    ## 186        <NA>       <NA>
    ## 187        <NA>       <NA>
    ## 188        <NA>       <NA>
    ## 189        <NA>       <NA>
    ## 190        2024       2010
    ## 191        2024       2010
    ## 192        2024       2010
    ## 193        2024       2015
    ## 194        2024       2015
    ## 195        <NA>       <NA>
    ## 196        <NA>       <NA>
    ## 197        2010       2018
    ## 198        2024       1990
    ## 199        2024       2010
    ## 200        2024       2000
    ## 201        <NA>       <NA>
    ## 202        2024       2010
    ## 203        2024       2010
    ## 204        2024       2000
    ## 205        2024       2016
    ## 206        2024       2000
    ## 207        2024       2015
    ## 208        2024       2004
    ## 209        2024       2000
    ## 210        2024       2010
    ## 211        2024       2010
    ## 212        2024       2010
    ## 213        2024       2015
    ## 214        2024       2007
    ## 215        2024       2018
    ## 216        2024       2002
    ## 217        2024       2015
    ## 218        2024       2017
    ## 219        2024       2013
    ## 220        2024       2015
    ## 221        2024       2015
    ## 222        2024       2018
    ## 223        2024       2005
    ## 224        2024       2000
    ## 225        2024       2010
    ## 226        2024       2010
    ## 227        2024       2000
    ## 228        2024       2010
    ## 229        <NA>       <NA>
    ## 230        <NA>       <NA>
    ## 231        2024       2019
    ## 232        2024       2019
    ## 233        2024       2019
    ## 234        2024       2017
    ## 235        2024       2017
    ## 236        <NA>       <NA>
    ## 237        2024       2021
    ## 238        2024       2015
    ## 239        <NA>       <NA>
    ## 240        2024       2010
    ## 241        2024       1989
    ## 242        2024       2010
    ## 243        2024       1989
    ## 244        2024       1989
    ## 245        2024       2015
    ## 246        2024       2010
    ## 247        2024       2000
    ## 248        2024       2000
    ## 249        <NA>       <NA>
    ## 250        2024       2010
    ## 251        2024       2010
    ## 252        2024       2000
    ## 253        2024       2018
    ## 254        2024       2000
    ## 255        2024       2018
    ## 256        2024       2000
    ## 257        2024       2010
    ## 258        2024       2010
    ## 259        2024       2010
    ## 260        2024       2017
    ## 261        2024       2018
    ## 262        2024       2010
    ## 263        2024       2016
    ## 264        2024       2019
    ## 265        2024       2002
    ## 266        2024       2000
    ## 267        2024       2019
    ## 268        2024       2019
    ## 269        2024       2020
    ## 270        2024       2007
    ## 271        2024       2004
    ## 272        2024       2000
    ## 273        2024       2003
    ## 274        2024       2019
    ## 275        2024       2019
    ## 276        2024       2016
    ## 277        2024       2020
    ## 278        1961       1921
    ## 279        1961       1921
    ## 280        1991       1922
    ## 281        1992       1940
    ## 282        1992       1960
    ## 283        1992       1941
    ## 284        1992       1941
    ## 285        1992       1943
    ## 286        1992       1940
    ## 287        1992       1962
    ## 288        1992       1960
    ## 289        1992       1946
    ## 290        1992       1952
    ## 291        1992       1940
    ## 292        1987       1960
    ## 293        1992       1918
    ## 294        1992       1933
    ## 295        1992       1938
    ## 296        1992       1940
    ## 297        1992       1940
    ## 298        1992       1960
    ## 299        1992       1921
    ## 300        1992       1921
    ## 301        1992       1940
    ## 302        1992       1940
    ## 303        1992       1958
    ## 304        1992       1924
    ## 305        1992       1940
    ## 306        1992       1940
    ## 307        1992       1945
    ## 308        1992       1950
    ## 309        1992       1950
    ## 310        1992       1950
    ## 311        1992       1944
    ## 312        1992       1940
    ## 313        1985       1922
    ## 314        1992       1940
    ## 315        1987       1940
    ## 316        1992       1965
    ## 317        1992       1965
    ## 318        1992       1950
    ## 319        1992       1960
    ## 320        1992       1940
    ## 321        1992       1925
    ## 322        1992       1925
    ## 323        1992       1980
    ## 324        1992       1924
    ## 325        1992       1940
    ## 326        1992       1940
    ## 327        1990       1940
    ## 328        1992       1940
    ## 329        1992       1980
    ## 330        1992       1940
    ## 331        1992       1940
    ## 332        1992       1956
    ## 333        1987       1948
    ## 334        1976       1960
    ## 335        1992       1940
    ## 336        1992       1970
    ## 337        1992       1922
    ## 338        1992       1965
    ## 339        1992       1940
    ## 340        1989       1940
    ## 341        1989       1970
    ## 342        1992       1900
    ## 343        1992       1934
    ## 344        1992       1934
    ## 345        1992       1935
    ## 346        1989       1956
    ## 347        1992       1925
    ## 348        1992       1970
    ## 349        1992       1970
    ## 350        1992       1965
    ## 351        1989       1935
    ## 352        1992       1950
    ## 353        1992       1960
    ## 354        1992       1960
    ## 355        1992       1962
    ## 356        1992       1955
    ## 357        1992       1950
    ## 358        1992       1960
    ## 359        1990       1940
    ## 360        1990       1940
    ## 361        1992       1970
    ## 362        1992       1970
    ## 363        1982       1940
    ## 364        1987       1960
    ## 365        1987       1955
    ## 366        1989       1955
    ## 367        1992       1921
    ## 368        1992       1940
    ## 369        1991       1952
    ## 370        1989       1942
    ## 371        1992       1925
    ## 372        1992       1925
    ## 373        1992       1925
    ## 374        1992       1935
    ## 375        1992       1930
    ## 376        1992       1950
    ## 377        1992       1940
    ## 378        1992       1947
    ## 379        1990       1960
    ## 380        1990       1980
    ## 381        1992       1940
    ## 382        2024       2014
    ## 383        2024       1960
    ## 384        2024       2014
    ## 385        2024       1990
    ## 386        2024       2020
    ## 387        2024       2000
    ## 388        2024       2014
    ## 389        <NA>       <NA>
    ## 390        <NA>       <NA>
    ## 391        2024       1960
    ## 392        2024       1960
    ## 393        2024       1960
    ## 394        2024       1960
    ## 395        2024       1960
    ## 396        2024       1960
    ## 397        2024       2004
    ## 398        2024       2009
    ## 399        2024       2010
    ## 400        2024       2014
    ## 401        2024       2014
    ## 402        2024       2014
    ## 403        <NA>       <NA>
    ## 404        2024       1989
    ## 405        2024       1989
    ## 406        2024       2003
    ## 407        <NA>       <NA>
    ## 408        2024       1989
    ## 409        <NA>       <NA>
    ## 410        2024       2008
    ## 411        2024       2017
    ## 412        2024       2002
    ## 413        2024       2003
    ## 414        2024       2003
    ## 415        2024       2002
    ## 416        2024       2002
    ## 417        2024       2004
    ## 418        2024       2004
    ## 419        2024       2004
    ## 420        <NA>       <NA>
    ## 421        <NA>       <NA>
    ## 422        2024       2007
    ## 423        2024       1989
    ## 424        <NA>       <NA>
    ## 425        <NA>       <NA>
    ## 426        2024       1990
    ## 427        2024       1989
    ## 428        2024       1989
    ## 429        2024       1995
    ## 430        2024       1989
    ## 431        <NA>       <NA>
    ## 432        <NA>       <NA>
    ## 433        <NA>       <NA>
    ## 434      2016M1     2025M2
    ## 435        <NA>       <NA>
    ## 436        <NA>       <NA>
    ## 437        2024       2000
    ## 438        2024       1971
    ## 439        2024       1971
    ## 440        <NA>       <NA>
    ## 441        <NA>       <NA>
    ## 442        2024       1991
    ## 443        2024       1991
    ## 444        2024       1991
    ## 445        2024       1971
    ## 446        2024       1971
    ## 447        2024       1989
    ## 448        2024       1970
    ## 449        2024       1991
    ## 450        2024       1971
    ## 451        2024       2010
    ## 452        <NA>       <NA>
    ## 453        2024       2010
    ## 454        <NA>       <NA>
    ## 455        2024       2013
    ## 456        2024       2005
    ## 457        2024       2005
    ## 458        2024       2006
    ## 459        2024       1999
    ## 460        2024       2006
    ## 461        <NA>       <NA>
    ## 462        2024       2006
    ## 463        <NA>       <NA>
    ## 464        <NA>       <NA>
    ## 465        <NA>       <NA>
    ## 466        <NA>       <NA>
    ## 467        2024       2017
    ## 468        <NA>       <NA>
    ## 469        2024       2017
    ## 470        2024       1925
    ## 471        2024       1929
    ## 472        2024       1998
    ## 473        2024       1940
    ## 474        2024       2012
    ## 475        2024       2007
    ## 476        2024       2016
    ## 477        2024       2016
    ## 478        2022       1995
    ## 479        2024       2007
    ## 480        2024       2023
    ## 481        2024       2023
    ## 482        2022       2010
    ## 483        2024       2009
    ## 484        2024       2011
    ## 485        2024       2009
    ## 486        2024       2009
    ## 487        2024       2009
    ## 488        2024       2016
    ## 489        2022       2002
    ## 490        2024       2010
    ## 491        2024       2007
    ## 492        2024       2009
    ## 493        2022       2009
    ## 494        2024       2009
    ## 495        2024       2009
    ## 496        2024       2009
    ## 497        2024       2012
    ## 498        2024       2010
    ## 499        2024       2005
    ## 500        2024       2004
    ## 501        2022       2009
    ## 502        2024       2010
    ## 503        2009       2023
    ## 504        2020       1963
    ## 505        <NA>       <NA>
    ## 506        <NA>       <NA>
    ## 507        <NA>       <NA>
    ## 508        <NA>       <NA>
    ## 509        <NA>       <NA>
    ## 510        2023       2009
    ## 511        2023       2019
    ## 512        2023       2009
    ## 513        2023       2019
    ## 514        <NA>       <NA>
    ## 515        <NA>       <NA>
    ## 516        <NA>       <NA>
    ## 517        2024       2017
    ## 518        <NA>       <NA>
    ## 519        2023       2015
    ## 520        2023       2015
    ## 521        2023       2015
    ## 522        2023       2017
    ## 523        2023       2017
    ## 524        2023       2017
    ## 525        2024       2013
    ## 526        2024       2013
    ## 527        2024       1998
    ## 528        <NA>       <NA>
    ## 529        <NA>       <NA>
    ## 530        <NA>       <NA>
    ## 531        <NA>       <NA>
    ## 532        <NA>       <NA>
    ## 533        2024       2013
    ## 534        <NA>       <NA>
    ## 535        <NA>       <NA>
    ## 536        <NA>       <NA>
    ## 537        <NA>       <NA>
    ## 538        2024       2013
    ## 539        2024       2013
    ## 540        <NA>       <NA>
    ## 541        <NA>       <NA>
    ## 542        <NA>       <NA>
    ## 543        <NA>       <NA>
    ## 544        2024       2013
    ## 545        2024       2013
    ## 546        <NA>       <NA>
    ## 547        <NA>       <NA>
    ## 548        <NA>       <NA>
    ## 549        <NA>       <NA>
    ## 550        <NA>       <NA>
    ## 551        <NA>       <NA>
    ## 552        2024       2000
    ## 553        2024       2011
    ## 554        2024       1990
    ## 555        2024       2001
    ## 556        2024       1956
    ## 557        2024       1935
    ## 558        2024       2014
    ## 559        2024       1963
    ## 560        2024       2003
    ## 561        2024       2012
    ## 562        2024       2003
    ## 563        2024       2003
    ## 564        2022       2003
    ## 565        2024       2013
    ## 566        2024       2003
    ## 567        2024       1935
    ## 568        2024       1935
    ## 569        2024       1963
    ## 570        2024       2010
    ## 571        2024       1963
    ## 572        2024       2010
    ## 573        2024       1983
    ## 574        2024       2000
    ## 575        2024       1990
    ## 576        2020       1969
    ## 577        2023       2003
    ## 578        2024       1990
    ## 579        <NA>       <NA>
    ## 580        2024       1934
    ## 581        2024       1934
    ## 582        2024       1989
    ## 583        2024       2010
    ## 584        2024       1989
    ## 585        2024       2010
    ## 586        2024       1989
    ## 587        2024       1989
    ## 588        2024       1992
    ## 589        2024       2010
    ## 590        2024       1970
    ## 591        2024       2006
    ## 592        2024       1995
    ## 593        2024       2010
    ## 594        2024       1970
    ## 595        2024       2010
    ## 596        2024       1989
    ## 597        2024       2000
    ## 598        2024       1980
    ## 599        2024       1980
    ## 600        2024       2010
    ## 601        2024       1963
    ## 602        2024       2010
    ## 603        2024       1980
    ## 604        2024       2010
    ## 605        2024       1992
    ## 606        2024       1980
    ## 607        2024       2010
    ## 608        2024       1957
    ## 609        2024       1957
    ## 610        2024       1989
    ## 611        2024       1989
    ## 612        2024       2003
    ## 613        2024       2010
    ## 614        2024       1992
    ## 615        2024       2010
    ## 616        2024       2010
    ## 617        2024       2000
    ## 618        2024       2010
    ## 619        2024       2008
    ## 620        2024       1992
    ## 621        2024       1992
    ## 622        2024       2012
    ## 623        2024       2012
    ## 624        2024       1996
    ## 625        2019       2019
    ## 626        2019       1994
    ## 627        2020       2010
    ## 628        2020       2010
    ## 629        2019       2019
    ## 630        2020       2000
    ## 631        2019       2019
    ## 632        2020       2010
    ## 633        2020       2010
    ## 634        2050       2020
    ## 635        2050       2020
    ## 636        2050       2020
    ## 637        2024       2014
    ## 638        2024       2011
    ## 639        2024       2011
    ## 640        2024       2011
    ## 641        2024       2014
    ## 642        2024       2014
    ## 643        2024       2014
    ## 644        2024       2014
    ## 645        <NA>       <NA>
    ## 646        <NA>       <NA>
    ## 647        2024       2014
    ## 648        <NA>       <NA>
    ## 649        2024       2003
    ## 650        2024       2003
    ## 651        2024       2013
    ## 652        2024       2013
    ## 653        2024       2003
    ## 654        2024       2003
    ## 655        2024       2003
    ## 656        2024       2003
    ## 657        2024       2000
    ## 658        2024       2016
    ## 659        2024       2000
    ## 660        2024       2015
    ## 661        2024       2000
    ## 662        2024       2007
    ## 663        2024       2003
    ## 664        2024       2000
    ## 665        2024       2018
    ## 666        2024       2000
    ## 667        2024       2018
    ## 668        2024       2000
    ## 669        2024       2010
    ## 670        2024       2010
    ## 671        2024       2010
    ## 672        2024       2019
    ## 673        2024       2015
    ## 674        2024       2010
    ## 675        2024       2018
    ## 676        2024       2002
    ## 677        2024       2015
    ## 678        2024       2017
    ## 679        2024       2013
    ## 680        2024       2017
    ## 681        2024       2018
    ## 682        2024       2022
    ## 683        2024       2022
    ## 684        2021       2020
    ## 685        2021       2020
    ## 686        2024       1990
    ## 687        2024       1990
    ## 688        2024       1990
    ## 689        2024       2015
    ## 690        2024       2015
    ## 691        2024       2016
    ## 692        2024       2016
    ## 693        2024       2015
    ## 694        2019       2019
    ## 695        2020       2010
    ## 696        2020       2010
    ## 697        2020       2000
    ## 698        2020       2010
    ## 699        2020       2010
    ## 700        2024       2000
    ## 701        2024       2020
    ## 702        <NA>       <NA>
    ## 703        2024       2020
    ## 704        <NA>       <NA>
    ## 705        2024       2000
    ## 706        <NA>       <NA>
    ## 707        2024       2007
    ## 708        2024       2002
    ## 709        2024       2007
    ## 710        2024       2007
    ## 711        2024       1995
    ## 712        2024       2002
    ## 713        2024       2002
    ## 714        2024       2002
    ## 715        2024       2005
    ## 716        2024       2002
    ## 717        2024       2000
    ## 718        2027       2002
    ## 719        2024       2016
    ## 720        2024       2000
    ## 721        <NA>       <NA>
    ## 722     2025-04    2019-03
    ## 723        2024       2010
    ## 724        2024       1971
    ## 725        2024       1970
    ## 726        2024       1971
    ## 727        2024       1991
    ## 728        2024       1992
    ## 729        2024       1991
    ## 730        2024       2013
    ## 731        2024       2010
    ## 732        2024       1991
    ## 733        2024       1991
    ## 734        2024       1991
    ## 735        2024       1991
    ## 736        2024       2004
    ## 737        2024       2004
    ## 738        2024       2004
    ## 739        2024       2000
    ## 740        2024       2000
    ## 741        2024       2001
    ## 742        2024       2000
    ## 743        2024       2000
    ## 744        2024       2015
    ## 745        2024       2000
    ## 746        2024       2000
    ## 747        2024       2011
    ## 748        2024       2011
    ## 749        2024       2001
    ## 750        2024       1935
    ## 751        2024       2014
    ## 752        2024       2003
    ## 753        2024       2012
    ## 754        2024       2010
    ## 755        2024       2012
    ## 756        2024       2012
    ## 757        2024       2008
    ## 758        2024       2010
    ## 759        2024       2006
    ## 760        2024       2010
    ## 761        2024       2010
    ## 762        2024       2010
    ## 763        2024       1992
    ## 764        2024       2012
    ## 765        2024       2012
    ## 766        2024       2012
    ## 767        2024       2010
    ## 768        2024       1983
    ## 769        2024       2010
    ## 770        2024       2010
    ## 771        2024       2000
    ## 772        2024       1990
    ## 773        2024       2007
    ## 774        2024       2007
    ## 775        2024       2007
    ## 776        2024       2007
    ## 777        2022       2010
    ## 778    2015=100   2023=100
    ## 779    2015=100   2023=100
    ## 780    2015=100   2023=100
    ## 781    2015=100   2023=100
    ## 782        2024       1991
    ## 783    2015=100   2023=100
    ## 784    2015=100   2023=100
    ## 785    2015=100   2023=100
    ## 786        2024       1991
    ## 787        2023       2015
    ## 788        2023       2017
    ## 789        2024       2013
    ## 790        2024       2013
    ## 791        <NA>       <NA>
    ## 792        <NA>       <NA>
    ## 793        <NA>       <NA>
    ## 794        <NA>       <NA>
    ## 795      2025-3     2013-4
    ## 796        2024       2014
    ## 797        <NA>       <NA>
    ## 798        2024       2017
    ## 799        <NA>       <NA>
    ## 800        <NA>       <NA>
    ## 801        <NA>       <NA>
    ## 802        <NA>       <NA>
    ## 803        <NA>       <NA>
    ## 804        2024       1925
    ## 805        <NA>       <NA>
    ## 806        <NA>       <NA>
    ## 807        <NA>       <NA>
    ## 808        2024       1929
    ## 809        2024       1998
    ## 810        2024       1940
    ## 811        2024       2012
    ## 812        2024       2007
    ## 813        <NA>       <NA>
    ## 814        <NA>       <NA>
    ## 815        <NA>       <NA>
    ## 816        <NA>       <NA>
    ## 817        <NA>       <NA>
    ## 818        2024       2003
    ## 819        2024       2003
    ## 820        2024       2003
    ## 821        2024       2013
    ## 822        2024       2013
    ## 823        2024       2003
    ## 824        2024       2003
    ## 825        2024       2003
    ## 826        2024       2003
    ## 827        2021       1993
    ## 828        2024       1992
    ## 829        2024       1992
    ## 830        2024       1992
    ## 831        2024       1992
    ## 832        2024       2007
    ## 833        2024       2016
    ## 834        2024       2013
    ## 835        2024       2013
    ## 836        2024       2017
    ## 837        2024       2017
    ## 838        2024       2020
    ## 839        2024       2020
    ## 840        2024       2022
    ## 841        2024       2022
    ## 842        2021       2020
    ## 843        2021       2020
    ## 844        2017       2017
    ## 845        2017       2017
    ## 846        2017       2017
    ## 847        2017       2017
    ## 848        2017       2017
    ## 849        2017       2017
    ## 850        2017       2017
    ## 851        2017       2017
    ## 852        2017       2017
    ## 853        2017       2017
    ## 854        2017       2017
    ## 855        2017       2017
    ## 856        2017       2017
    ## 857        2017       2017
    ## 858        2017       2017
    ## 859        2017       2017
    ## 860        2017       2017
    ## 861        2017       2017
    ## 862        2017       2017
    ## 863        2017       2017
    ## 864        2017       2017
    ## 865        2017       2017
    ## 866        2017       2017
    ## 867        2024       1997
    ## 868        2024       2007
    ## 869        2024       1997
    ## 870        2024       2007
    ## 871        2024       1997
    ## 872        2024       2007
    ## 873        2024       1997
    ## 874        2024       2007
    ## 875        2024       1989
    ## 876        2024       1992
    ## 877        1996       1966
    ## 878        1996       1966
    ## 879        <NA>       <NA>
    ## 880        <NA>       <NA>
    ## 881        <NA>       <NA>
    ## 882        <NA>       <NA>
    ## 883        <NA>       <NA>
    ## 884        2024       2011
    ## 885        2024       2011
    ## 886        <NA>       <NA>
    ## 887        <NA>       <NA>
    ## 888        2024       2000
    ## 889        2024       2011
    ## 890        2024       2000
    ## 891        2024       2011
    ## 892        2013       2000
    ## 893        2024       2011
    ## 894        2024       2004
    ## 895        2024       2000
    ## 896        2024       2020
    ## 897        2024       2020
    ## 898        2024       2018
    ## 899        2024       2000
    ## 900        2024       2010
    ## 901        2024       2010
    ## 902        2024       2010
    ## 903        2024       2007
    ## 904        2024       2002
    ## 905        2024       2007
    ## 906        2024       2007
    ## 907        2024       1995
    ## 908        2024       2002
    ## 909        2024       2002
    ## 910        2024       2002
    ## 911        2024       2005
    ## 912        2024       2002
    ## 913        2024       2000
    ## 914        2027       2002
    ## 915        2024       2011
    ## 916        2024       2011
    ## 917        2024       2011
    ## 918        2024       2000
    ## 919        2024       2014
    ## 920        2024       2012
    ## 921        2024       2016
    ## 922        2024       2016
    ## 923        2024       2017
    ## 924        2024       2016
    ## 925        2024       2016
    ## 926        2024       2016
    ## 927        2024       2010
    ## 928        2024       2000
    ## 929        2024       2010
    ## 930        2024       2016
    ## 931        2024       2018
    ## 932        2024       2010
    ## 933        2024       2010
    ## 934        2024       2015
    ## 935        <NA>       <NA>
    ## 936        <NA>       <NA>
    ## 937        2024       2018
    ## 938        2024       2010
    ## 939        2014       2002
    ## 940        2014       2002
    ## 941        2014       2002
    ## 942        2014       2002
    ## 943        2014       2002
    ## 944        2015       2000
    ## 945        2015       1998
    ## 946        2015       2003
    ## 947        2015       1997
    ## 948        2015       1990
    ## 949        2010       1990
    ## 950        2015       1995
    ## 951        2015       1997
    ## 952        2015       2000
    ## 953        2015       1990
    ## 954        2015       1990
    ## 955        2012       1992
    ## 956        2020       1990
    ## 957        2015       1990
    ## 958        2015       1991
    ## 959        2020       1990
    ## 960        2015       1990
    ## 961        2015       2005
    ## 962        2015       2007
    ## 963        2014       1990
    ## 964        2014       1990
    ## 965        2014       1990
    ## 966        2014       1995
    ## 967        2012       1990
    ## 968        2014       1990
    ## 969        2012       1990
    ## 970        2014       2000
    ## 971        2014       2000
    ## 972        2014       2006
    ## 973        2012       2006
    ## 974        2013       2000
    ## 975        2013       2000
    ## 976        2010       2010
    ## 977        2014       1993
    ## 978        2014       1991
    ## 979        2014       2000
    ## 980        2014       1990
    ## 981        2014       1991
    ## 982        2014       2005
    ## 983        2014       1991
    ## 984        2014       2000
    ## 985        2014       1991
    ## 986        2014       2000
    ## 987        <NA>       <NA>
    ## 988        2014       1990
    ## 989        2014       1999
    ## 990        2014       1999
    ## 991        2014       2000
    ## 992        2014       2004
    ## 993        2014       2004
    ## 994        2014       2008
    ## 995        2014       2008
    ## 996        2013       2009
    ## 997        2014       2008
    ## 998        2013       2000
    ## 999        2024       2010
    ## 1000       2013       2005
    ## 1001       2013       2000
    ## 1002       2013       2005
    ## 1003       2013       2005
    ## 1004       2013       2000
    ## 1005       2010       2005
    ## 1006       2010       2000
    ## 1007       2010       2000
    ## 1008       2010       2000
    ## 1009       2010       2005
    ## 1010       2010       2005
    ## 1011       2010       2000
    ## 1012       2010       2005
    ## 1013       2010       2000
    ## 1014       2010       2000
    ## 1015       2010       2000
    ## 1016       2010       2005
    ## 1017       2010       2005
    ## 1018       2010       2000
    ## 1019       2010       2005
    ## 1020       2024       2004
    ## 1021       2024       2004
    ## 1022       2024       2004
    ## 1023       2020       1995
    ## 1024       2022       2022
    ## 1025       2020       2003
    ## 1026       2025       2001
    ## 1027       2020       2003
    ## 1028       2020       2003
    ## 1029       2022       2008
    ## 1030       2000       1999
    ## 1031       2011       2011
    ## 1032       2020       2016
    ## 1033       2022       2010
    ## 1034       2024       2018
    ## 1035       2024       2018
    ## 1036       2024       2018
    ## 1037       2024       2018
    ## 1038       2024       2018
    ## 1039       2024       2018
    ## 1040       2024       2018
    ## 1041       2024       2018
    ## 1042       2024       2018
    ## 1043       2024       2018
    ## 1044       2024       2018
    ## 1045       2024       2018
    ## 1046       2024       2018
    ## 1047       2024       2018
    ## 1048       2024       2018
    ## 1049       2024       2018
    ## 1050       2024       2018
    ## 1051       2024       2018
    ## 1052       2024       2018
    ## 1053       2024       2018
    ## 1054       2024       2018
    ## 1055       2024       2018
    ## 1056       2024       2018
    ## 1057       2018       2024
    ## 1058       2024       2018
    ## 1059       2024       2018
    ## 1060       2016       2014
    ## 1061       <NA>       <NA>
    ## 1062       <NA>       <NA>
    ## 1063       <NA>       <NA>
    ## 1064       <NA>       <NA>
    ## 1065       <NA>       <NA>
    ## 1066       <NA>       <NA>
    ## 1067       <NA>       <NA>
    ## 1068       <NA>       <NA>
    ## 1069       <NA>       <NA>
    ## 1070       <NA>       <NA>
    ## 1071       <NA>       <NA>
    ## 1072       <NA>       <NA>
    ## 1073       <NA>       <NA>
    ## 1074       <NA>       <NA>
    ## 1075       <NA>       <NA>
    ## 1076       <NA>       <NA>
    ## 1077       <NA>       <NA>
    ## 1078       <NA>       <NA>
    ## 1079       <NA>       <NA>
    ## 1080       <NA>       <NA>
    ## 1081       <NA>       <NA>
    ## 1082       2024       1989
    ## 1083       <NA>       <NA>
    ## 1084       <NA>       <NA>
    ## 1085       2024       1990
    ## 1086    2025-02    2019-02
    ## 1087       2024       2018
    ## 1088    2025-02    2019-02
    ## 1089       2024       2018
    ## 1090    2025-02    2019-02
    ## 1091       2024       2018
    ## 1092    2025-02    2019-02
    ## 1093       2024       2018
    ## 1094    2025-02    2019-02
    ## 1095       2024       2018
    ## 1096       2024       2018
    ## 1097    2025-02    2019-02
    ## 1098       2024       2018
    ## 1099    2025-02    2019-02
    ## 1100       2024       2018
    ## 1101    2025-02    2019-02
    ## 1102       2024       2018
    ## 1103    2025-02    2019-02
    ## 1104       2024       2018
    ## 1105    2025-02    2019-02
    ## 1106       2024       2018
    ## 1107    2025-02    2019-02
    ## 1108       2024       2018
    ## 1109    2025-02    2019-02
    ## 1110       2024       2018
    ## 1111       <NA>       <NA>
    ## 1112       2024       1940
    ## 1113       <NA>       <NA>
    ## 1114       2024       2001
    ## 1115       <NA>       <NA>
    ## 1116       2024       1999
    ## 1117       <NA>       <NA>
    ## 1118       2024       1960
    ## 1119       <NA>       <NA>
    ## 1120       2024       1960
    ## 1121       <NA>       <NA>
    ## 1122       <NA>       <NA>
    ## 1123       2024       1995
    ## 1124       <NA>       <NA>
    ## 1125       <NA>       <NA>
    ## 1126       2024       1999
    ## 1127       <NA>       <NA>
    ## 1128       <NA>       <NA>
    ## 1129       2024       1999
    ## 1130       <NA>       <NA>
    ## 1131       <NA>       <NA>
    ## 1132       2024       1999
    ## 1133       <NA>       <NA>
    ## 1134       2024       1999
    ## 1135       <NA>       <NA>
    ## 1136       <NA>       <NA>
    ## 1137       <NA>       <NA>
    ## 1138       <NA>       <NA>
    ## 1139       <NA>       <NA>
    ## 1140       <NA>       <NA>
    ## 1141       2024       2015
    ## 1142       <NA>       <NA>
    ## 1143       <NA>       <NA>
    ## 1144       2024       1957
    ## 1145       <NA>       <NA>
    ## 1146       2024       1925
    ## 1147       <NA>       <NA>
    ## 1148       <NA>       <NA>
    ## 1149       2024       1942
    ## 1150       2024       2018
    ## 1151       <NA>       <NA>
    ## 1152       2024       1992
    ## 1153       <NA>       <NA>
    ## 1154       2024       1992
    ## 1155       <NA>       <NA>
    ## 1156       2024       1985
    ## 1157       <NA>       <NA>
    ## 1158       2024       2009
    ## 1159       <NA>       <NA>
    ## 1160       2018       1985
    ## 1161       <NA>       <NA>
    ## 1162       2024       2019
    ## 1163       <NA>       <NA>
    ## 1164       2024       2016
    ## 1165       <NA>       <NA>
    ## 1166       2024       2016
    ## 1167       <NA>       <NA>
    ## 1168       2024       1992
    ## 1169       <NA>       <NA>
    ## 1170       2024       1992
    ## 1171       <NA>       <NA>
    ## 1172       2024       1992
    ## 1173       <NA>       <NA>
    ## 1174       2024       2009
    ## 1175       <NA>       <NA>
    ## 1176       2024       2016
    ## 1177       <NA>       <NA>
    ## 1178       2024       1992
    ## 1179       <NA>       <NA>
    ## 1180       2024       2012
    ## 1181       <NA>       <NA>
    ## 1182       <NA>       <NA>
    ## 1183       2024       2020
    ## 1184       2024       2001
    ## 1185       <NA>       <NA>
    ## 1186       2024       2007
    ## 1187     2025-1     2000-4
    ## 1188       2024       2014
    ## 1189       <NA>       <NA>
    ## 1190       2024       2001
    ## 1191       <NA>       <NA>
    ## 1192       2024       2001
    ## 1193       <NA>       <NA>
    ## 1194       2024       1995
    ## 1195       <NA>       <NA>
    ## 1196       2024       2017
    ## 1197       <NA>       <NA>
    ## 1198       <NA>       <NA>
    ## 1199       2024       2017
    ## 1200       2024       2000
    ## 1201       <NA>       <NA>
    ## 1202       2024       2020
    ## 1203       <NA>       <NA>
    ## 1204       2024       2000
    ## 1205       <NA>       <NA>
    ## 1206       2024       2000
    ## 1207       <NA>       <NA>
    ## 1208       2024       1989
    ## 1209       <NA>       <NA>
    ## 1210       2024       2003
    ## 1211       <NA>       <NA>
    ## 1212       2024       2010
    ## 1213       <NA>       <NA>
    ## 1214       <NA>       <NA>
    ## 1215       2024       1995
    ## 1216       <NA>       <NA>
    ## 1217       2024       2012
    ## 1218       2024       2004
    ## 1219       <NA>       <NA>
    ## 1220       <NA>       <NA>
    ## 1221       2024       1995
    ## 1222       <NA>       <NA>
    ## 1223       2024       2021
    ## 1224       <NA>       <NA>
    ## 1225       2024       1995
    ##                                                                                                                                                        list_id
    ## 1                                                                                                                     Economy, environment/Balance of Payments
    ## 2                                                                                                                    Economy, environment/Consumer Price Index
    ## 3                                                                                                                    Economy, environment/Consumer Price Index
    ## 4                                                                                                                    Economy, environment/Consumer Price Index
    ## 5                                                                                                                    Economy, environment/Consumer Price Index
    ## 6                                                                                                                    Economy, environment/Consumer Price Index
    ## 7                                                                                                                    Economy, environment/Consumer Price Index
    ## 8                                                                                                                    Economy, environment/Consumer Price Index
    ## 9                                                                                                                    Economy, environment/Consumer Price Index
    ## 10                                                                                                                   Economy, environment/Consumer Price Index
    ## 11                                                                                                                   Economy, environment/Consumer Price Index
    ## 12                                                                                                                   Economy, environment/Consumer Price Index
    ## 13                                                                                                                   Economy, environment/Consumer Price Index
    ## 14                                                                                                                   Economy, environment/Consumer Price Index
    ## 15                                                                                                                   Economy, environment/Consumer Price Index
    ## 16                                                                                                                   Economy, environment/Consumer Price Index
    ## 17                                                                                                                   Economy, environment/Consumer Price Index
    ## 18                                                                                                                   Economy, environment/Consumer Price Index
    ## 19                                                                                                                   Economy, environment/Consumer Price Index
    ## 20                                                                                                                   Economy, environment/Consumer Price Index
    ## 21                                                                                                                   Economy, environment/Consumer Price Index
    ## 22                                                                                                                   Economy, environment/Consumer Price Index
    ## 23                                                                                                                            Economy, environment/Environment
    ## 24                                                                                                                            Economy, environment/Environment
    ## 25                                                                                                                            Economy, environment/Environment
    ## 26                                                                                                                            Economy, environment/Environment
    ## 27                                                                                                                            Economy, environment/Environment
    ## 28                                                                                                                            Economy, environment/Environment
    ## 29                                                                                                                            Economy, environment/Environment
    ## 30                                                                                                                            Economy, environment/Environment
    ## 31                                                                                                                            Economy, environment/Environment
    ## 32                                                                                                                            Economy, environment/Environment
    ## 33                                                                                                                            Economy, environment/Environment
    ## 34                                                                                                                            Economy, environment/Environment
    ## 35                                                                                                                            Economy, environment/Environment
    ## 36                                                                                                                            Economy, environment/Environment
    ## 37                                                                                                                            Economy, environment/Environment
    ## 38                                                                                                                            Economy, environment/Environment
    ## 39                                                                                                                            Economy, environment/Environment
    ## 40                                                                                                                            Economy, environment/Environment
    ## 41                                                                                                         Economy, environment/Environmental-Economic Account
    ## 42                                                                                                         Economy, environment/Environmental-Economic Account
    ## 43                                                                                                         Economy, environment/Environmental-Economic Account
    ## 44                                                                                                         Economy, environment/Environmental-Economic Account
    ## 45                                                                                                         Economy, environment/Environmental-Economic Account
    ## 46                                                                                                         Economy, environment/Environmental-Economic Account
    ## 47                                                                                                         Economy, environment/Environmental-Economic Account
    ## 48                                                                                                         Economy, environment/Environmental-Economic Account
    ## 49                                                                                                         Economy, environment/Environmental-Economic Account
    ## 50                                                                                                         Economy, environment/Environmental-Economic Account
    ## 51                                                                                                         Economy, environment/Environmental-Economic Account
    ## 52                                                                                                         Economy, environment/Environmental-Economic Account
    ## 53                                                                                                         Economy, environment/Environmental-Economic Account
    ## 54                                                                                                         Economy, environment/Environmental-Economic Account
    ## 55                                                                                                         Economy, environment/Environmental-Economic Account
    ## 56                                                                                                         Economy, environment/Environmental-Economic Account
    ## 57                                                                                                         Economy, environment/Environmental-Economic Account
    ## 58                                                                                                         Economy, environment/Environmental-Economic Account
    ## 59                                                                                                                          Economy, environment/Foreign Trade
    ## 60                                                                                                                          Economy, environment/Foreign Trade
    ## 61                                                                                                                          Economy, environment/Foreign Trade
    ## 62                                                                                                                          Economy, environment/Foreign Trade
    ## 63                                                                                                                          Economy, environment/Foreign Trade
    ## 64                                                                                                                          Economy, environment/Foreign Trade
    ## 65                                                                                                                          Economy, environment/Foreign Trade
    ## 66                                                                                                                          Economy, environment/Foreign Trade
    ## 67                                                                                                                          Economy, environment/Foreign Trade
    ## 68                                                                                                                          Economy, environment/Foreign Trade
    ## 69                                                                                                                          Economy, environment/Foreign Trade
    ## 70                                                                                                                          Economy, environment/Foreign Trade
    ## 71                                                                                                                          Economy, environment/Foreign Trade
    ## 72                                                                                                                          Economy, environment/Foreign Trade
    ## 73                                                                                                                          Economy, environment/Foreign Trade
    ## 74                                                                                                                          Economy, environment/Foreign Trade
    ## 75                                                                                                                          Economy, environment/Foreign Trade
    ## 76                                                                                                                      Economy, environment/Government budget
    ## 77                                                                                                                      Economy, environment/Government budget
    ## 78                                                                                                                      Economy, environment/Government budget
    ## 79                                                                                                                      Economy, environment/Government budget
    ## 80                                                                                                                      Economy, environment/Government budget
    ## 81                                                                                                                      Economy, environment/Government budget
    ## 82                                                                                                                      Economy, environment/Government budget
    ## 83                                                                                                                      Economy, environment/Government budget
    ## 84                                                                                                                      Economy, environment/Government budget
    ## 85                                                                                                                      Economy, environment/Government budget
    ## 86                                                                                                                      Economy, environment/Government budget
    ## 87                                                                                                                      Economy, environment/Government budget
    ## 88                                                                                                                      Economy, environment/Government budget
    ## 89                                                                                                                      Economy, environment/Government budget
    ## 90                                                                                                                      Economy, environment/Government budget
    ## 91                                                                                                                    Economy, environment/Housing price index
    ## 92                                                                                                                    Economy, environment/Housing price index
    ## 93                                                                                                                    Economy, environment/Housing price index
    ## 94                                                                                                                    Economy, environment/Housing price index
    ## 95                                                                                                                    Economy, environment/Housing price index
    ## 96                                                                                                                    Economy, environment/Housing price index
    ## 97                                                                                                                             Economy, environment/Investment
    ## 98                                                                                                                             Economy, environment/Investment
    ## 99                                                                                                                             Economy, environment/Investment
    ## 100                                                                                                                            Economy, environment/Investment
    ## 101                                                                                                                            Economy, environment/Investment
    ## 102                                                                                                                            Economy, environment/Investment
    ## 103                                                                                                                            Economy, environment/Investment
    ## 104                                                                                                                            Economy, environment/Investment
    ## 105                                                                                                                            Economy, environment/Investment
    ## 106                                                                                                                            Economy, environment/Investment
    ## 107                                                                                                                            Economy, environment/Investment
    ## 108                                                                                                                            Economy, environment/Investment
    ## 109                                                                                                                     Economy, environment/Money and Finance
    ## 110                                                                                                                     Economy, environment/Money and Finance
    ## 111                                                                                                                     Economy, environment/Money and Finance
    ## 112                                                                                                                     Economy, environment/Money and Finance
    ## 113                                                                                                                     Economy, environment/Money and Finance
    ## 114                                                                                                                     Economy, environment/Money and Finance
    ## 115                                                                                                                     Economy, environment/Money and Finance
    ## 116                                                                                                                     Economy, environment/Money and Finance
    ## 117                                                                                                                     Economy, environment/Money and Finance
    ## 118                                                                                                                     Economy, environment/Money and Finance
    ## 119                                                                                                                     Economy, environment/Money and Finance
    ## 120                                                                                                                     Economy, environment/Money and Finance
    ## 121                                                                                                                     Economy, environment/Money and Finance
    ## 122                                                                                                                     Economy, environment/Money and Finance
    ## 123                                                                                                                     Economy, environment/Money and Finance
    ## 124                                                                                                                     Economy, environment/Money and Finance
    ## 125                                                                                                                     Economy, environment/Money and Finance
    ## 126                                                                                                                     Economy, environment/Money and Finance
    ## 127                                                                                                                     Economy, environment/Money and Finance
    ## 128                                                                                                                     Economy, environment/Money and Finance
    ## 129                                                                                                                     Economy, environment/Money and Finance
    ## 130                                                                                                                     Economy, environment/National Accounts
    ## 131                                                                                                                     Economy, environment/National Accounts
    ## 132                                                                                                                     Economy, environment/National Accounts
    ## 133                                                                                                                     Economy, environment/National Accounts
    ## 134                                                                                                                     Economy, environment/National Accounts
    ## 135                                                                                                                     Economy, environment/National Accounts
    ## 136                                                                                                                     Economy, environment/National Accounts
    ## 137                                                                                                                     Economy, environment/National Accounts
    ## 138                                                                                                                     Economy, environment/National Accounts
    ## 139                                                                                                                     Economy, environment/National Accounts
    ## 140                                                                                                                     Economy, environment/National Accounts
    ## 141                                                                                                                     Economy, environment/National Accounts
    ## 142                                                                                                                     Economy, environment/National Accounts
    ## 143                                                                                                                     Economy, environment/National Accounts
    ## 144                                                                                                                     Economy, environment/National Accounts
    ## 145                                                                                                                     Economy, environment/National Accounts
    ## 146                                                                                                                     Economy, environment/National Accounts
    ## 147                                                                                                                     Economy, environment/National Accounts
    ## 148                                                                                                                     Economy, environment/National Accounts
    ## 149                                                                                                                     Economy, environment/National Accounts
    ## 150                                                                                                                     Economy, environment/National Accounts
    ## 151                                                                                                                     Economy, environment/National Accounts
    ## 152                                                                                                                     Economy, environment/National Accounts
    ## 153                                                                                                                     Economy, environment/National Accounts
    ## 154                                                                                                                     Economy, environment/National Accounts
    ## 155                                                                                                                          Economy, environment/Productivity
    ## 156                                                                                                                          Economy, environment/Productivity
    ## 157                                                                                                                          Economy, environment/Productivity
    ## 158                                                                                                                           Education, health/Births, deaths
    ## 159                                                                                                                           Education, health/Births, deaths
    ## 160                                                                                                                           Education, health/Births, deaths
    ## 161                                                                                                                           Education, health/Births, deaths
    ## 162                                                                                                                           Education, health/Births, deaths
    ## 163                                                                                                                           Education, health/Births, deaths
    ## 164                                                                                                                           Education, health/Births, deaths
    ## 165                                                                                                                           Education, health/Births, deaths
    ## 166                                                                                                                           Education, health/Births, deaths
    ## 167                                                                                                                           Education, health/Births, deaths
    ## 168                                                                                                                           Education, health/Births, deaths
    ## 169                                                                                                                           Education, health/Births, deaths
    ## 170                                                                                                                           Education, health/Births, deaths
    ## 171                                                                                                                           Education, health/Births, deaths
    ## 172                                                                                                                           Education, health/Births, deaths
    ## 173                                                                                                                           Education, health/Births, deaths
    ## 174                                                                                                                           Education, health/Births, deaths
    ## 175                                                                                                                           Education, health/Births, deaths
    ## 176                                                                                                                           Education, health/Births, deaths
    ## 177                                                                                                                           Education, health/Births, deaths
    ## 178                                                                                                                           Education, health/Births, deaths
    ## 179                                                                                                                           Education, health/Births, deaths
    ## 180                                                                                                                           Education, health/Births, deaths
    ## 181                                                                                                                           Education, health/Births, deaths
    ## 182                                                                                                                           Education, health/Births, deaths
    ## 183                                                                                                                           Education, health/Births, deaths
    ## 184                                                                                                                           Education, health/Births, deaths
    ## 185                                                                                                                           Education, health/Births, deaths
    ## 186                                                                                                                           Education, health/Births, deaths
    ## 187                                                                                                                           Education, health/Births, deaths
    ## 188                                                                                                                           Education, health/Births, deaths
    ## 189                                                                                                                           Education, health/Births, deaths
    ## 190                                                                                                                           Education, health/Births, deaths
    ## 191                                                                                                                           Education, health/Births, deaths
    ## 192                                                                                                                           Education, health/Births, deaths
    ## 193                                                                                                                           Education, health/Births, deaths
    ## 194                                                                                                                           Education, health/Births, deaths
    ## 195                                                                                                                           Education, health/Births, deaths
    ## 196                                                                                                                           Education, health/Births, deaths
    ## 197                                                                                                                           Education, health/Births, deaths
    ## 198                                                                                                                                  Education, health/Disease
    ## 199                                                                                                                                  Education, health/Disease
    ## 200                                                                                                                                  Education, health/Disease
    ## 201                                                                                                                                  Education, health/Disease
    ## 202                                                                                                                                  Education, health/Disease
    ## 203                                                                                                                                  Education, health/Disease
    ## 204                                                                                                              Education, health/General educational schools
    ## 205                                                                                                              Education, health/General educational schools
    ## 206                                                                                                              Education, health/General educational schools
    ## 207                                                                                                              Education, health/General educational schools
    ## 208                                                                                                              Education, health/General educational schools
    ## 209                                                                                                              Education, health/General educational schools
    ## 210                                                                                                              Education, health/General educational schools
    ## 211                                                                                                              Education, health/General educational schools
    ## 212                                                                                                              Education, health/General educational schools
    ## 213                                                                                                              Education, health/General educational schools
    ## 214                                                                                                              Education, health/General educational schools
    ## 215                                                                                                              Education, health/General educational schools
    ## 216                                                                                                              Education, health/General educational schools
    ## 217                                                                                                              Education, health/General educational schools
    ## 218                                                                                                              Education, health/General educational schools
    ## 219                                                                                                              Education, health/General educational schools
    ## 220                                                                                                              Education, health/General educational schools
    ## 221                                                                                                              Education, health/General educational schools
    ## 222                                                                                                              Education, health/General educational schools
    ## 223                                                                                                         Education, health/General indicators for Education
    ## 224                                                                                                         Education, health/General indicators for Education
    ## 225                                                                                                         Education, health/General indicators for Education
    ## 226                                                                                                         Education, health/General indicators for Education
    ## 227                                                                                                         Education, health/General indicators for Education
    ## 228                                                                                                         Education, health/General indicators for Education
    ## 229                                                                                                                         Education, health/Health insurance
    ## 230                                                                                                                         Education, health/Health insurance
    ## 231                                                                                                                         Education, health/Health insurance
    ## 232                                                                                                                         Education, health/Health insurance
    ## 233                                                                                                                         Education, health/Health insurance
    ## 234                                                                                                        Education, health/Main indicators for Health sector
    ## 235                                                                                                        Education, health/Main indicators for Health sector
    ## 236                                                                                                        Education, health/Main indicators for Health sector
    ## 237                                                                                                        Education, health/Main indicators for Health sector
    ## 238                                                                                                        Education, health/Main indicators for Health sector
    ## 239                                                                                                        Education, health/Main indicators for Health sector
    ## 240                                                                                                        Education, health/Main indicators for Health sector
    ## 241                                                                                                        Education, health/Main indicators for Health sector
    ## 242                                                                                                        Education, health/Main indicators for Health sector
    ## 243                                                                                                        Education, health/Main indicators for Health sector
    ## 244                                                                                                        Education, health/Main indicators for Health sector
    ## 245                                                                                                        Education, health/Main indicators for Health sector
    ## 246                                                                                                        Education, health/Main indicators for Health sector
    ## 247                                                                                                        Education, health/Main indicators for Health sector
    ## 248                                                                                                        Education, health/Main indicators for Health sector
    ## 249                                                                                                        Education, health/Main indicators for Health sector
    ## 250                                                                                                        Education, health/Main indicators for Health sector
    ## 251                                                                                                        Education, health/Main indicators for Health sector
    ## 252                                                                                                                     Education, health/Pre-school education
    ## 253                                                                                                                     Education, health/Pre-school education
    ## 254                                                                                                                     Education, health/Pre-school education
    ## 255                                                                                                                     Education, health/Pre-school education
    ## 256                                                                                                                     Education, health/Pre-school education
    ## 257                                                                                                                     Education, health/Pre-school education
    ## 258                                                                                                                     Education, health/Pre-school education
    ## 259                                                                                                                     Education, health/Pre-school education
    ## 260                                                                                                                     Education, health/Pre-school education
    ## 261                                                                                                                     Education, health/Pre-school education
    ## 262                                                                                                    Education, health/Universities, institutes and colleges
    ## 263                                                                                                    Education, health/Universities, institutes and colleges
    ## 264                                                                                                    Education, health/Universities, institutes and colleges
    ## 265                                                                                                    Education, health/Universities, institutes and colleges
    ## 266                                                                                                    Education, health/Universities, institutes and colleges
    ## 267                                                                                                    Education, health/Universities, institutes and colleges
    ## 268                                                                                                    Education, health/Universities, institutes and colleges
    ## 269                                                                                                    Education, health/Universities, institutes and colleges
    ## 270                                                                                                                     Education, health/Vocational education
    ## 271                                                                                                                     Education, health/Vocational education
    ## 272                                                                                                                     Education, health/Vocational education
    ## 273                                                                                                                     Education, health/Vocational education
    ## 274                                                                                                                     Education, health/Vocational education
    ## 275                                                                                                                     Education, health/Vocational education
    ## 276                                                                                                                     Education, health/Vocational education
    ## 277                                                                                                                     Education, health/Vocational education
    ## 278                                                                                             Historical data/Administrative territorial division of the MPR
    ## 279                                                                                             Historical data/Administrative territorial division of the MPR
    ## 280                                                                                                                                Historical data/Agriculture
    ## 281                                                                                                                                Historical data/Agriculture
    ## 282                                                                                                                                Historical data/Agriculture
    ## 283                                                                                                                                Historical data/Agriculture
    ## 284                                                                                                                                Historical data/Agriculture
    ## 285                                                                                                                                Historical data/Agriculture
    ## 286                                                                                                                                Historical data/Agriculture
    ## 287                                                                                                                                Historical data/Agriculture
    ## 288                                                                                                                                Historical data/Agriculture
    ## 289                                                                                                                                Historical data/Agriculture
    ## 290                                                                                                                                Historical data/Agriculture
    ## 291                                                                                                                                Historical data/Agriculture
    ## 292                                                                                                                                Historical data/Agriculture
    ## 293                                                                                                                                Historical data/Agriculture
    ## 294                                                                                                                                Historical data/Agriculture
    ## 295                                                                                                                                Historical data/Agriculture
    ## 296                                                                                                                                Historical data/Agriculture
    ## 297                                                                                                                                Historical data/Agriculture
    ## 298                                                                                                                                Historical data/Agriculture
    ## 299                                                                                                             Historical data/Education, culture and science
    ## 300                                                                                                             Historical data/Education, culture and science
    ## 301                                                                                                             Historical data/Education, culture and science
    ## 302                                                                                                             Historical data/Education, culture and science
    ## 303                                                                                                             Historical data/Education, culture and science
    ## 304                                                                                                             Historical data/Education, culture and science
    ## 305                                                                                                             Historical data/Education, culture and science
    ## 306                                                                                                             Historical data/Education, culture and science
    ## 307                                                                                                             Historical data/Education, culture and science
    ## 308                                                                                                             Historical data/Education, culture and science
    ## 309                                                                                                             Historical data/Education, culture and science
    ## 310                                                                                                             Historical data/Education, culture and science
    ## 311                                                                                                             Historical data/Education, culture and science
    ## 312                                                                                                                                 Historical data/Enterprise
    ## 313                                                                                                                                 Historical data/Enterprise
    ## 314                                                                                                                                 Historical data/Enterprise
    ## 315                                                                                                                                 Historical data/Enterprise
    ## 316                                                                                                                                 Historical data/Enterprise
    ## 317                                                                                                                                 Historical data/Enterprise
    ## 318                                                                                                                                 Historical data/Enterprise
    ## 319                                                                                                                          Historical data/Health protection
    ## 320                                                                                                                          Historical data/Health protection
    ## 321                                                                                                                          Historical data/Health protection
    ## 322                                                                                                                          Historical data/Health protection
    ## 323                                                                                                                       Historical data/Integrated_Indicator
    ## 324                                                                                                                       Historical data/Integrated_Indicator
    ## 325                                                                                                                       Historical data/Integrated_Indicator
    ## 326                                                                                                                       Historical data/Integrated_Indicator
    ## 327                                                                                                                       Historical data/Integrated_Indicator
    ## 328                                                                                                                       Historical data/Integrated_Indicator
    ## 329                                                                                                                       Historical data/Integrated_Indicator
    ## 330                                                                                                                       Historical data/Integrated_Indicator
    ## 331                                                                                                                Historical data/Investment and construction
    ## 332                                                                                                                Historical data/Investment and construction
    ## 333                                                                                                                Historical data/Investment and construction
    ## 334                                                                                                                Historical data/Investment and construction
    ## 335                                                                                                                Historical data/Investment and construction
    ## 336                                                                                                                Historical data/Investment and construction
    ## 337                                                                                                                Historical data/Investment and construction
    ## 338                                                                                                                        Historical data/Number of employees
    ## 339                                                                                                                        Historical data/Number of employees
    ## 340                                                                                                                        Historical data/Number of employees
    ## 341                                                                                                                        Historical data/Number of employees
    ## 342                                                                                                                                 Historical data/Population
    ## 343                                                                                                                                 Historical data/Population
    ## 344                                                                                                                                 Historical data/Population
    ## 345                                                                                                                                 Historical data/Population
    ## 346                                                                                                                                 Historical data/Population
    ## 347                                                                                                                                 Historical data/Population
    ## 348                                                                                                                                 Historical data/Population
    ## 349                                                                                                                                 Historical data/Population
    ## 350                                                                                                                                 Historical data/Population
    ## 351                                                                                                                                 Historical data/Population
    ## 352                                                                                                                                 Historical data/Population
    ## 353                                                                                                            Historical data/Progress of people's activities
    ## 354                                                                                                            Historical data/Progress of people's activities
    ## 355                                                                                                            Historical data/Progress of people's activities
    ## 356                                                                                                            Historical data/Progress of people's activities
    ## 357                                                                                                            Historical data/Progress of people's activities
    ## 358                                                                                                            Historical data/Progress of people's activities
    ## 359                                                                                                                               Historical data/State budget
    ## 360                                                                                                                               Historical data/State budget
    ## 361                                                                                                                                      Historical data/Trade
    ## 362                                                                                                                                      Historical data/Trade
    ## 363                                                                                                                                      Historical data/Trade
    ## 364                                                                                                                                      Historical data/Trade
    ## 365                                                                                                                                      Historical data/Trade
    ## 366                                                                                                                                      Historical data/Trade
    ## 367                                                                                                                                      Historical data/Trade
    ## 368                                                                                                                                      Historical data/Trade
    ## 369                                                                                                                                      Historical data/Trade
    ## 370                                                                                                                                      Historical data/Trade
    ## 371                                                                                                                Historical data/Transport and communication
    ## 372                                                                                                                Historical data/Transport and communication
    ## 373                                                                                                                Historical data/Transport and communication
    ## 374                                                                                                                Historical data/Transport and communication
    ## 375                                                                                                                Historical data/Transport and communication
    ## 376                                                                                                                Historical data/Transport and communication
    ## 377                                                                                                                Historical data/Transport and communication
    ## 378                                                                                                                Historical data/Transport and communication
    ## 379                                                                                                                     Historical data/Utilities and services
    ## 380                                                                                                                     Historical data/Utilities and services
    ## 381                                                                                                                     Historical data/Utilities and services
    ## 382                                                                                                                              Industry, service/Agriculture
    ## 383                                                                                                                              Industry, service/Agriculture
    ## 384                                                                                                                              Industry, service/Agriculture
    ## 385                                                                                                                              Industry, service/Agriculture
    ## 386                                                                                                                              Industry, service/Agriculture
    ## 387                                                                                                                              Industry, service/Agriculture
    ## 388                                                                                                                              Industry, service/Agriculture
    ## 389                                                                                                                              Industry, service/Agriculture
    ## 390                                                                                                                              Industry, service/Agriculture
    ## 391                                                                                                                              Industry, service/Agriculture
    ## 392                                                                                                                              Industry, service/Agriculture
    ## 393                                                                                                                              Industry, service/Agriculture
    ## 394                                                                                                                              Industry, service/Agriculture
    ## 395                                                                                                                              Industry, service/Agriculture
    ## 396                                                                                                                              Industry, service/Agriculture
    ## 397                                                                                                                              Industry, service/Agriculture
    ## 398                                                                                                                              Industry, service/Agriculture
    ## 399                                                                                                                              Industry, service/Agriculture
    ## 400                                                                                                                              Industry, service/Agriculture
    ## 401                                                                                                                              Industry, service/Agriculture
    ## 402                                                                                                                              Industry, service/Agriculture
    ## 403                                                                                                                             Industry, service/Construction
    ## 404                                                                                                                             Industry, service/Construction
    ## 405                                                                                                                             Industry, service/Construction
    ## 406                                                                                                                             Industry, service/Construction
    ## 407                                                                                                                             Industry, service/Construction
    ## 408                                                                                                                             Industry, service/Construction
    ## 409                                                                                                                             Industry, service/Construction
    ## 410                                                                                                      Industry, service/Culture, cultural creative industry
    ## 411                                                                                                      Industry, service/Culture, cultural creative industry
    ## 412                                                                                                      Industry, service/Culture, cultural creative industry
    ## 413                                                                                                      Industry, service/Culture, cultural creative industry
    ## 414                                                                                                      Industry, service/Culture, cultural creative industry
    ## 415                                                                                                      Industry, service/Culture, cultural creative industry
    ## 416                                                                                                      Industry, service/Culture, cultural creative industry
    ## 417                                                                                                      Industry, service/Culture, cultural creative industry
    ## 418                                                                                                      Industry, service/Culture, cultural creative industry
    ## 419                                                                                                      Industry, service/Culture, cultural creative industry
    ## 420                                                                                                                                 Industry, service/Industry
    ## 421                                                                                                                                 Industry, service/Industry
    ## 422                                                                                                                                 Industry, service/Industry
    ## 423                                                                                                                                 Industry, service/Industry
    ## 424                                                                                                                                 Industry, service/Industry
    ## 425                                                                                                                                 Industry, service/Industry
    ## 426                                                                                                                                 Industry, service/Industry
    ## 427                                                                                                                                 Industry, service/Industry
    ## 428                                                                                                                                 Industry, service/Industry
    ## 429                                                                                                                                 Industry, service/Industry
    ## 430                                                                                                                                 Industry, service/Industry
    ## 431                                                                                                                                 Industry, service/Industry
    ## 432                                                                                                                                 Industry, service/Industry
    ## 433                                                                                                                                 Industry, service/Industry
    ## 434                                                                                                                                 Industry, service/Industry
    ## 435                                                                                                                                 Industry, service/Industry
    ## 436                                                                                                                                 Industry, service/Industry
    ## 437                                                                                                                                Industry, service/Livestock
    ## 438                                                                                                                                Industry, service/Livestock
    ## 439                                                                                                                                Industry, service/Livestock
    ## 440                                                                                                                                Industry, service/Livestock
    ## 441                                                                                                                                Industry, service/Livestock
    ## 442                                                                                                                                Industry, service/Livestock
    ## 443                                                                                                                                Industry, service/Livestock
    ## 444                                                                                                                                Industry, service/Livestock
    ## 445                                                                                                                                Industry, service/Livestock
    ## 446                                                                                                                                Industry, service/Livestock
    ## 447                                                                                                                                Industry, service/Livestock
    ## 448                                                                                                                                Industry, service/Livestock
    ## 449                                                                                                                                Industry, service/Livestock
    ## 450                                                                                                                                Industry, service/Livestock
    ## 451                                                                                                                                Industry, service/Livestock
    ## 452                                                                                                                                Industry, service/Livestock
    ## 453                                                                                                                                Industry, service/Livestock
    ## 454                                                                                                                                Industry, service/Livestock
    ## 455                                                                                                                                Industry, service/Livestock
    ## 456                                                                                                                                  Industry, service/Science
    ## 457                                                                                                                                  Industry, service/Science
    ## 458                                                                                                                                  Industry, service/Tourism
    ## 459                                                                                                                                  Industry, service/Tourism
    ## 460                                                                                                                                  Industry, service/Tourism
    ## 461                                                                                                                                  Industry, service/Tourism
    ## 462                                                                                                                                  Industry, service/Tourism
    ## 463                                                                                                                                  Industry, service/Tourism
    ## 464                                                                                                                                  Industry, service/Tourism
    ## 465                                                                                                                                  Industry, service/Tourism
    ## 466                                                                                                                                  Industry, service/Tourism
    ## 467                                                                                                              Industry, service/Trade, hotel and restaurant
    ## 468                                                                                                              Industry, service/Trade, hotel and restaurant
    ## 469                                                                                                              Industry, service/Trade, hotel and restaurant
    ## 470                                                                                                                           Industry, service/Transportation
    ## 471                                                                                                                           Industry, service/Transportation
    ## 472                                                                                                                           Industry, service/Transportation
    ## 473                                                                                                                           Industry, service/Transportation
    ## 474                                                                                                                           Industry, service/Transportation
    ## 475                                                                                                                           Industry, service/Transportation
    ## 476                                                                                                                            Labour, business/Civil servants
    ## 477                                                                                                                            Labour, business/Civil servants
    ## 478                                                                                                                            Labour, business/Civil servants
    ## 479                                                                                                                            Labour, business/Civil servants
    ## 480                                                                                                                            Labour, business/Civil servants
    ## 481                                                                                                                            Labour, business/Civil servants
    ## 482                                                                                                                               Labour, business/Decent work
    ## 483                                                                                                                               Labour, business/Decent work
    ## 484                                                                                                                               Labour, business/Decent work
    ## 485                                                                                                                               Labour, business/Decent work
    ## 486                                                                                                                               Labour, business/Decent work
    ## 487                                                                                                                               Labour, business/Decent work
    ## 488                                                                                                                               Labour, business/Decent work
    ## 489                                                                                                                               Labour, business/Decent work
    ## 490                                                                                                                               Labour, business/Decent work
    ## 491                                                                                                                               Labour, business/Decent work
    ## 492                                                                                                                               Labour, business/Decent work
    ## 493                                                                                                                               Labour, business/Decent work
    ## 494                                                                                                                               Labour, business/Decent work
    ## 495                                                                                                                               Labour, business/Decent work
    ## 496                                                                                                                               Labour, business/Decent work
    ## 497                                                                                                                               Labour, business/Decent work
    ## 498                                                                                                                               Labour, business/Decent work
    ## 499                                                                                                                               Labour, business/Decent work
    ## 500                                                                                                                               Labour, business/Decent work
    ## 501                                                                                                                               Labour, business/Decent work
    ## 502                                                                                                                               Labour, business/Decent work
    ## 503                                                                                                                               Labour, business/Decent work
    ## 504                                                                                                                               Labour, business/Decent work
    ## 505                                                                                                                                    Labour, business/Labour
    ## 506                                                                                                                                    Labour, business/Labour
    ## 507                                                                                                                                    Labour, business/Labour
    ## 508                                                                                                                                    Labour, business/Labour
    ## 509                                                                                                                                    Labour, business/Labour
    ## 510                                                                                                                                    Labour, business/Labour
    ## 511                                                                                                                                    Labour, business/Labour
    ## 512                                                                                                                                    Labour, business/Labour
    ## 513                                                                                                                                    Labour, business/Labour
    ## 514                                                                                                                                    Labour, business/Labour
    ## 515                                                                                                                                    Labour, business/Labour
    ## 516                                                                                                                                    Labour, business/Labour
    ## 517                                                                                                                                    Labour, business/Labour
    ## 518                                                                                                                                    Labour, business/Labour
    ## 519                                                                                                                                      Labour, business/SMEs
    ## 520                                                                                                                                      Labour, business/SMEs
    ## 521                                                                                                                                      Labour, business/SMEs
    ## 522                                                                                                                                      Labour, business/SMEs
    ## 523                                                                                                                                      Labour, business/SMEs
    ## 524                                                                                                                                      Labour, business/SMEs
    ## 525                                                                                                             Labour, business/Statistical Business Register
    ## 526                                                                                                             Labour, business/Statistical Business Register
    ## 527                                                                                                             Labour, business/Statistical Business Register
    ## 528                                                                                                             Labour, business/Statistical Business Register
    ## 529                                                                                                             Labour, business/Statistical Business Register
    ## 530                                                                                                             Labour, business/Statistical Business Register
    ## 531                                                                                                             Labour, business/Statistical Business Register
    ## 532                                                                                                             Labour, business/Statistical Business Register
    ## 533                                                                                                             Labour, business/Statistical Business Register
    ## 534                                                                                                             Labour, business/Statistical Business Register
    ## 535                                                                                                             Labour, business/Statistical Business Register
    ## 536                                                                                                             Labour, business/Statistical Business Register
    ## 537                                                                                                             Labour, business/Statistical Business Register
    ## 538                                                                                                             Labour, business/Statistical Business Register
    ## 539                                                                                                             Labour, business/Statistical Business Register
    ## 540                                                                                                             Labour, business/Statistical Business Register
    ## 541                                                                                                             Labour, business/Statistical Business Register
    ## 542                                                                                                             Labour, business/Statistical Business Register
    ## 543                                                                                                             Labour, business/Statistical Business Register
    ## 544                                                                                                             Labour, business/Statistical Business Register
    ## 545                                                                                                             Labour, business/Statistical Business Register
    ## 546                                                                                                             Labour, business/Statistical Business Register
    ## 547                                                                                                             Labour, business/Statistical Business Register
    ## 548                                                                                                             Labour, business/Statistical Business Register
    ## 549                                                                                                             Labour, business/Statistical Business Register
    ## 550                                                                                                             Labour, business/Statistical Business Register
    ## 551                                                                                                             Labour, business/Statistical Business Register
    ## 552                                                                                                              Population, household/1_Population, household
    ## 553                                                                                                              Population, household/1_Population, household
    ## 554                                                                                                              Population, household/1_Population, household
    ## 555                                                                                                              Population, household/1_Population, household
    ## 556                                                                                                              Population, household/1_Population, household
    ## 557                                                                                                              Population, household/1_Population, household
    ## 558                                                                                                              Population, household/1_Population, household
    ## 559                                                                                                              Population, household/1_Population, household
    ## 560                                                                                                              Population, household/1_Population, household
    ## 561                                                                                                              Population, household/1_Population, household
    ## 562                                                                                                              Population, household/1_Population, household
    ## 563                                                                                                              Population, household/1_Population, household
    ## 564                                                                                                              Population, household/1_Population, household
    ## 565                                                                                                              Population, household/1_Population, household
    ## 566                                                                                                              Population, household/1_Population, household
    ## 567                                                                                                              Population, household/1_Population, household
    ## 568                                                                                                              Population, household/1_Population, household
    ## 569                                                                                                              Population, household/1_Population, household
    ## 570                                                                                                              Population, household/1_Population, household
    ## 571                                                                                                              Population, household/1_Population, household
    ## 572                                                                                                              Population, household/1_Population, household
    ## 573                                                                                                              Population, household/1_Population, household
    ## 574                                                                                                              Population, household/1_Population, household
    ## 575                                                                                                              Population, household/1_Population, household
    ## 576                                                                                                              Population, household/1_Population, household
    ## 577                                                                                                              Population, household/1_Population, household
    ## 578                                                                                                              Population, household/1_Population, household
    ## 579                                                                                                     Population, household/2_Regular movement of population
    ## 580                                                                                                     Population, household/2_Regular movement of population
    ## 581                                                                                                     Population, household/2_Regular movement of population
    ## 582                                                                                                     Population, household/2_Regular movement of population
    ## 583                                                                                                     Population, household/2_Regular movement of population
    ## 584                                                                                                     Population, household/2_Regular movement of population
    ## 585                                                                                                     Population, household/2_Regular movement of population
    ## 586                                                                                                     Population, household/2_Regular movement of population
    ## 587                                                                                                     Population, household/2_Regular movement of population
    ## 588                                                                                                     Population, household/2_Regular movement of population
    ## 589                                                                                                     Population, household/2_Regular movement of population
    ## 590                                                                                                     Population, household/2_Regular movement of population
    ## 591                                                                                                     Population, household/2_Regular movement of population
    ## 592                                                                                                     Population, household/2_Regular movement of population
    ## 593                                                                                                     Population, household/2_Regular movement of population
    ## 594                                                                                                     Population, household/2_Regular movement of population
    ## 595                                                                                                     Population, household/2_Regular movement of population
    ## 596                                                                                                     Population, household/2_Regular movement of population
    ## 597                                                                                                     Population, household/2_Regular movement of population
    ## 598                                                                                                     Population, household/2_Regular movement of population
    ## 599                                                                                                     Population, household/2_Regular movement of population
    ## 600                                                                                                     Population, household/2_Regular movement of population
    ## 601                                                                                                     Population, household/2_Regular movement of population
    ## 602                                                                                                     Population, household/2_Regular movement of population
    ## 603                                                                                                     Population, household/2_Regular movement of population
    ## 604                                                                                                     Population, household/2_Regular movement of population
    ## 605                                                                                                     Population, household/2_Regular movement of population
    ## 606                                                                                                     Population, household/2_Regular movement of population
    ## 607                                                                                                     Population, household/2_Regular movement of population
    ## 608                                                                                                     Population, household/2_Regular movement of population
    ## 609                                                                                                     Population, household/2_Regular movement of population
    ## 610                                                                                                     Population, household/2_Regular movement of population
    ## 611                                                                                                     Population, household/2_Regular movement of population
    ## 612                                                                                                     Population, household/2_Regular movement of population
    ## 613                                                                                                     Population, household/2_Regular movement of population
    ## 614                                                                                                     Population, household/2_Regular movement of population
    ## 615                                                                                                     Population, household/2_Regular movement of population
    ## 616                                                                                                     Population, household/2_Regular movement of population
    ## 617                                                                                                     Population, household/2_Regular movement of population
    ## 618                                                                                                     Population, household/2_Regular movement of population
    ## 619                                                                                                                           Population, household/3_Herdsmen
    ## 620                                                                                                                           Population, household/3_Herdsmen
    ## 621                                                                                                                           Population, household/3_Herdsmen
    ## 622                                                                                                                           Population, household/3_Herdsmen
    ## 623                                                                                                                           Population, household/3_Herdsmen
    ## 624                                                                                                                           Population, household/3_Herdsmen
    ## 625                                                                                                            Population, household/3_Infrastructure, housing
    ## 626                                                                                                            Population, household/3_Infrastructure, housing
    ## 627                                                                                                            Population, household/3_Infrastructure, housing
    ## 628                                                                                                            Population, household/3_Infrastructure, housing
    ## 629                                                                                                            Population, household/3_Infrastructure, housing
    ## 630                                                                                                            Population, household/3_Infrastructure, housing
    ## 631                                                                                                            Population, household/3_Infrastructure, housing
    ## 632                                                                                                            Population, household/3_Infrastructure, housing
    ## 633                                                                                                            Population, household/3_Infrastructure, housing
    ## 634                                                                                                              Population, household/4_Population projection
    ## 635                                                                                                              Population, household/4_Population projection
    ## 636                                                                                                              Population, household/4_Population projection
    ## 637                                                                                                     Population, household/5_Adminstrative units, territory
    ## 638                                                                                                     Population, household/5_Adminstrative units, territory
    ## 639                                                                                                     Population, household/5_Adminstrative units, territory
    ## 640                                                                                                     Population, household/5_Adminstrative units, territory
    ## 641                                                                                                                           Regional development/Agriculture
    ## 642                                                                                                                           Regional development/Agriculture
    ## 643                                                                                                                           Regional development/Agriculture
    ## 644                                                                                                                           Regional development/Agriculture
    ## 645                                                                                                                          Regional development/Construction
    ## 646                                                                                                                          Regional development/Construction
    ## 647                                                                                                                          Regional development/Construction
    ## 648                                                                                                                          Regional development/Construction
    ## 649                                                                                                                            Regional development/Disability
    ## 650                                                                                                                            Regional development/Disability
    ## 651                                                                                                                            Regional development/Disability
    ## 652                                                                                                                            Regional development/Disability
    ## 653                                                                                                                            Regional development/Disability
    ## 654                                                                                                                            Regional development/Disability
    ## 655                                                                                                                            Regional development/Disability
    ## 656                                                                                                                            Regional development/Disability
    ## 657                                                                                         Regional development/Education, Science, and Intellectual Property
    ## 658                                                                                         Regional development/Education, Science, and Intellectual Property
    ## 659                                                                                         Regional development/Education, Science, and Intellectual Property
    ## 660                                                                                         Regional development/Education, Science, and Intellectual Property
    ## 661                                                                                         Regional development/Education, Science, and Intellectual Property
    ## 662                                                                                         Regional development/Education, Science, and Intellectual Property
    ## 663                                                                                         Regional development/Education, Science, and Intellectual Property
    ## 664                                                                                         Regional development/Education, Science, and Intellectual Property
    ## 665                                                                                         Regional development/Education, Science, and Intellectual Property
    ## 666                                                                                         Regional development/Education, Science, and Intellectual Property
    ## 667                                                                                         Regional development/Education, Science, and Intellectual Property
    ## 668                                                                                         Regional development/Education, Science, and Intellectual Property
    ## 669                                                                                         Regional development/Education, Science, and Intellectual Property
    ## 670                                                                                         Regional development/Education, Science, and Intellectual Property
    ## 671                                                                                         Regional development/Education, Science, and Intellectual Property
    ## 672                                                                                         Regional development/Education, Science, and Intellectual Property
    ## 673                                                                                         Regional development/Education, Science, and Intellectual Property
    ## 674                                                                                         Regional development/Education, Science, and Intellectual Property
    ## 675                                                                                         Regional development/Education, Science, and Intellectual Property
    ## 676                                                                                         Regional development/Education, Science, and Intellectual Property
    ## 677                                                                                         Regional development/Education, Science, and Intellectual Property
    ## 678                                                                                         Regional development/Education, Science, and Intellectual Property
    ## 679                                                                                         Regional development/Education, Science, and Intellectual Property
    ## 680                                                                                         Regional development/Education, Science, and Intellectual Property
    ## 681                                                                                         Regional development/Education, Science, and Intellectual Property
    ## 682                                                                                                                              Regional development/Election
    ## 683                                                                                                                              Regional development/Election
    ## 684                                                                                                                              Regional development/Election
    ## 685                                                                                                                              Regional development/Election
    ## 686                                                                                                                     Regional development/Government budget
    ## 687                                                                                                                     Regional development/Government budget
    ## 688                                                                                                                     Regional development/Government budget
    ## 689                                                                                                                     Regional development/Human development
    ## 690                                                                                                                     Regional development/Human development
    ## 691                                                                                                                     Regional development/Human development
    ## 692                                                                                                                     Regional development/Human development
    ## 693                                                                                                                     Regional development/Human development
    ## 694                                                                                                               Regional development/Infrastructure, housing
    ## 695                                                                                                               Regional development/Infrastructure, housing
    ## 696                                                                                                               Regional development/Infrastructure, housing
    ## 697                                                                                                               Regional development/Infrastructure, housing
    ## 698                                                                                                               Regional development/Infrastructure, housing
    ## 699                                                                                                               Regional development/Infrastructure, housing
    ## 700                                                                                                                     Regional development/Justice and crime
    ## 701                                                                                                                     Regional development/Justice and crime
    ## 702                                                                                                                     Regional development/Justice and crime
    ## 703                                                                                                                     Regional development/Justice and crime
    ## 704                                                                                                                     Regional development/Justice and crime
    ## 705                                                                                                                     Regional development/Justice and crime
    ## 706                                                                                                                     Regional development/Justice and crime
    ## 707                                                                                                                     Regional development/Justice and crime
    ## 708                                                                                                                     Regional development/Justice and crime
    ## 709                                                                                                                     Regional development/Justice and crime
    ## 710                                                                                                                     Regional development/Justice and crime
    ## 711                                                                                                                     Regional development/Justice and crime
    ## 712                                                                                                                     Regional development/Justice and crime
    ## 713                                                                                                                     Regional development/Justice and crime
    ## 714                                                                                                                     Regional development/Justice and crime
    ## 715                                                                                                                     Regional development/Justice and crime
    ## 716                                                                                                                     Regional development/Justice and crime
    ## 717                                                                                                                     Regional development/Justice and crime
    ## 718                                                                                                                     Regional development/Justice and crime
    ## 719                                                                                                                     Regional development/Justice and crime
    ## 720                                                                                                                     Regional development/Justice and crime
    ## 721                                                                                                                     Regional development/Justice and crime
    ## 722                                                                                                                     Regional development/Justice and crime
    ## 723                                                                                                                     Regional development/Justice and crime
    ## 724                                                                                                                             Regional development/Livestock
    ## 725                                                                                                                             Regional development/Livestock
    ## 726                                                                                                                             Regional development/Livestock
    ## 727                                                                                                                             Regional development/Livestock
    ## 728                                                                                                                             Regional development/Livestock
    ## 729                                                                                                                             Regional development/Livestock
    ## 730                                                                                                                             Regional development/Livestock
    ## 731                                                                                                                             Regional development/Livestock
    ## 732                                                                                                                             Regional development/Livestock
    ## 733                                                                                                                             Regional development/Livestock
    ## 734                                                                                                                             Regional development/Livestock
    ## 735                                                                                                                             Regional development/Livestock
    ## 736                                                                                                     Regional development/Monasteries, Temples and Churches
    ## 737                                                                                                     Regional development/Monasteries, Temples and Churches
    ## 738                                                                                                     Regional development/Monasteries, Temples and Churches
    ## 739                                                                                                                     Regional development/Money and Finance
    ## 740                                                                                                                     Regional development/Money and Finance
    ## 741                                                                                                                     Regional development/Money and Finance
    ## 742                                                                                                                     Regional development/National accounts
    ## 743                                                                                                                     Regional development/National accounts
    ## 744                                                                                                                     Regional development/National accounts
    ## 745                                                                                                                     Regional development/National accounts
    ## 746                                                                                                                     Regional development/National accounts
    ## 747                                                                                                                     Regional development/National accounts
    ## 748                                                                                                                     Regional development/National accounts
    ## 749                                                                                                              Regional development/Population and household
    ## 750                                                                                                              Regional development/Population and household
    ## 751                                                                                                              Regional development/Population and household
    ## 752                                                                                                              Regional development/Population and household
    ## 753                                                                                                              Regional development/Population and household
    ## 754                                                                                                              Regional development/Population and household
    ## 755                                                                                                              Regional development/Population and household
    ## 756                                                                                                              Regional development/Population and household
    ## 757                                                                                                              Regional development/Population and household
    ## 758                                                                                                              Regional development/Population and household
    ## 759                                                                                                              Regional development/Population and household
    ## 760                                                                                                              Regional development/Population and household
    ## 761                                                                                                              Regional development/Population and household
    ## 762                                                                                                              Regional development/Population and household
    ## 763                                                                                                              Regional development/Population and household
    ## 764                                                                                                              Regional development/Population and household
    ## 765                                                                                                              Regional development/Population and household
    ## 766                                                                                                              Regional development/Population and household
    ## 767                                                                                                              Regional development/Population and household
    ## 768                                                                                                              Regional development/Population and household
    ## 769                                                                                                              Regional development/Population and household
    ## 770                                                                                                              Regional development/Population and household
    ## 771                                                                                                              Regional development/Population and household
    ## 772                                                                                                              Regional development/Population and household
    ## 773                                                                                                                 Regional development/Population livelihood
    ## 774                                                                                                                 Regional development/Population livelihood
    ## 775                                                                                                                 Regional development/Population livelihood
    ## 776                                                                                                                 Regional development/Population livelihood
    ## 777                                                                                                                 Regional development/Population livelihood
    ## 778                                                                                                                                 Regional development/Price
    ## 779                                                                                                                                 Regional development/Price
    ## 780                                                                                                                                 Regional development/Price
    ## 781                                                                                                                                 Regional development/Price
    ## 782                                                                                                                                 Regional development/Price
    ## 783                                                                                                                                 Regional development/Price
    ## 784                                                                                                                                 Regional development/Price
    ## 785                                                                                                                                 Regional development/Price
    ## 786                                                                                                                                 Regional development/Price
    ## 787                                                                                                                                  Regional development/SMEs
    ## 788                                                                                                                                  Regional development/SMEs
    ## 789                                                                                                         Regional development/Statistical business register
    ## 790                                                                                                         Regional development/Statistical business register
    ## 791                                                                                                         Regional development/Statistical business register
    ## 792                                                                                                         Regional development/Statistical business register
    ## 793                                                                                                         Regional development/Statistical business register
    ## 794                                                                                                         Regional development/Statistical business register
    ## 795                                                                                                         Regional development/Statistical business register
    ## 796                                                                                                       Regional development/Territory, administrative units
    ## 797                                                                                                                                 Regional development/Trade
    ## 798                                                                                                                                 Regional development/Trade
    ## 799                                                                                                                                 Regional development/Trade
    ## 800                                                                                                                                 Regional development/Trade
    ## 801                                                                                                                                 Regional development/Trade
    ## 802                                                                                                                                 Regional development/Trade
    ## 803                                                                                                                        Regional development/Transportation
    ## 804                                                                                                                        Regional development/Transportation
    ## 805                                                                                                                        Regional development/Transportation
    ## 806                                                                                                                        Regional development/Transportation
    ## 807                                                                                                                        Regional development/Transportation
    ## 808                                                                                                                        Regional development/Transportation
    ## 809                                                                                                                        Regional development/Transportation
    ## 810                                                                                                                        Regional development/Transportation
    ## 811                                                                                                                        Regional development/Transportation
    ## 812                                                                                                                        Regional development/Transportation
    ## 813                                                                                                                        Regional development/Transportation
    ## 814                                                                                                                        Regional development/Transportation
    ## 815                                                                                                                        Regional development/Transportation
    ## 816                                                                                                                        Regional development/Transportation
    ## 817                                                                                                                        Regional development/Transportation
    ## 818                                                                                                                            Society, development/Disability
    ## 819                                                                                                                            Society, development/Disability
    ## 820                                                                                                                            Society, development/Disability
    ## 821                                                                                                                            Society, development/Disability
    ## 822                                                                                                                            Society, development/Disability
    ## 823                                                                                                                            Society, development/Disability
    ## 824                                                                                                                            Society, development/Disability
    ## 825                                                                                                                            Society, development/Disability
    ## 826                                                                                                                            Society, development/Disability
    ## 827                                                                                                                              Society, development/Election
    ## 828                                                                                                                              Society, development/Election
    ## 829                                                                                                                              Society, development/Election
    ## 830                                                                                                                              Society, development/Election
    ## 831                                                                                                                              Society, development/Election
    ## 832                                                                                                                         Society, development/Food Security
    ## 833                                                                                                                         Society, development/Food Security
    ## 834                                                                                                                         Society, development/Food Security
    ## 835                                                                                                                         Society, development/Food Security
    ## 836                                                                                                                         Society, development/Food Security
    ## 837                                                                                                                         Society, development/Food Security
    ## 838                                                                                                                         Society, development/Food Security
    ## 839                                                                                                                         Society, development/Food Security
    ## 840                                                                                                                                Society, development/Gender
    ## 841                                                                                                                                Society, development/Gender
    ## 842                                                                                                                                Society, development/Gender
    ## 843                                                                                                                                Society, development/Gender
    ## 844                                                                                                                                Society, development/Gender
    ## 845                                                                                                                                Society, development/Gender
    ## 846                                                                                                                                Society, development/Gender
    ## 847                                                                                                                                Society, development/Gender
    ## 848                                                                                                                                Society, development/Gender
    ## 849                                                                                                                                Society, development/Gender
    ## 850                                                                                                                                Society, development/Gender
    ## 851                                                                                                                                Society, development/Gender
    ## 852                                                                                                                                Society, development/Gender
    ## 853                                                                                                                                Society, development/Gender
    ## 854                                                                                                                                Society, development/Gender
    ## 855                                                                                                                                Society, development/Gender
    ## 856                                                                                                                                Society, development/Gender
    ## 857                                                                                                                                Society, development/Gender
    ## 858                                                                                                                                Society, development/Gender
    ## 859                                                                                                                                Society, development/Gender
    ## 860                                                                                                                                Society, development/Gender
    ## 861                                                                                                                                Society, development/Gender
    ## 862                                                                                                                                Society, development/Gender
    ## 863                                                                                                                                Society, development/Gender
    ## 864                                                                                                                                Society, development/Gender
    ## 865                                                                                                                                Society, development/Gender
    ## 866                                                                                                                                Society, development/Gender
    ## 867                                                                                                      Society, development/Household income and expenditure
    ## 868                                                                                                      Society, development/Household income and expenditure
    ## 869                                                                                                      Society, development/Household income and expenditure
    ## 870                                                                                                      Society, development/Household income and expenditure
    ## 871                                                                                                      Society, development/Household income and expenditure
    ## 872                                                                                                      Society, development/Household income and expenditure
    ## 873                                                                                                      Society, development/Household income and expenditure
    ## 874                                                                                                      Society, development/Household income and expenditure
    ## 875                                                                                                      Society, development/Household income and expenditure
    ## 876                                                                                                      Society, development/Household income and expenditure
    ## 877                                                                                                      Society, development/Household income and expenditure
    ## 878                                                                                                      Society, development/Household income and expenditure
    ## 879                                                                                                      Society, development/Household income and expenditure
    ## 880                                                                                                      Society, development/Household income and expenditure
    ## 881                                                                                                      Society, development/Household income and expenditure
    ## 882                                                                                                      Society, development/Household income and expenditure
    ## 883                                                                                                      Society, development/Household income and expenditure
    ## 884                                                                                                      Society, development/Household income and expenditure
    ## 885                                                                                                      Society, development/Household income and expenditure
    ## 886                                                                                                      Society, development/Household income and expenditure
    ## 887                                                                                                      Society, development/Household income and expenditure
    ## 888                                                                                                               Society, development/Human Development Index
    ## 889                                                                                                               Society, development/Human Development Index
    ## 890                                                                                                               Society, development/Human Development Index
    ## 891                                                                                                               Society, development/Human Development Index
    ## 892                                                                                                               Society, development/Human Development Index
    ## 893                                                                                                               Society, development/Human Development Index
    ## 894                                                                                                               Society, development/Human Development Index
    ## 895                                                                                                                         Society, development/Law and crime
    ## 896                                                                                                                         Society, development/Law and crime
    ## 897                                                                                                                         Society, development/Law and crime
    ## 898                                                                                                                         Society, development/Law and crime
    ## 899                                                                                                                         Society, development/Law and crime
    ## 900                                                                                                                         Society, development/Law and crime
    ## 901                                                                                                                         Society, development/Law and crime
    ## 902                                                                                                                         Society, development/Law and crime
    ## 903                                                                                                                         Society, development/Law and crime
    ## 904                                                                                                                         Society, development/Law and crime
    ## 905                                                                                                                         Society, development/Law and crime
    ## 906                                                                                                                         Society, development/Law and crime
    ## 907                                                                                                                         Society, development/Law and crime
    ## 908                                                                                                                         Society, development/Law and crime
    ## 909                                                                                                                         Society, development/Law and crime
    ## 910                                                                                                                         Society, development/Law and crime
    ## 911                                                                                                                         Society, development/Law and crime
    ## 912                                                                                                                         Society, development/Law and crime
    ## 913                                                                                                                         Society, development/Law and crime
    ## 914                                                                                                                         Society, development/Law and crime
    ## 915                                                                                                                         Society, development/Law and crime
    ## 916                                                                                                                         Society, development/Law and crime
    ## 917                                                                                                                         Society, development/Law and crime
    ## 918                                                                                                                         Society, development/Law and crime
    ## 919                                                                                                                         Society, development/Law and crime
    ## 920                                                                                                                         Society, development/Law and crime
    ## 921                                                                                                                         Society, development/Law and crime
    ## 922                                                                                                                         Society, development/Law and crime
    ## 923                                                                                                                         Society, development/Law and crime
    ## 924                                                                                                                         Society, development/Law and crime
    ## 925                                                                                                                         Society, development/Law and crime
    ## 926                                                                                                                         Society, development/Law and crime
    ## 927                                                                                                                         Society, development/Law and crime
    ## 928                                                                                                                         Society, development/Law and crime
    ## 929                                                                                                                         Society, development/Law and crime
    ## 930                                                                                                                         Society, development/Law and crime
    ## 931                                                                                                                         Society, development/Law and crime
    ## 932                                                                                                                         Society, development/Law and crime
    ## 933                                                                                                                         Society, development/Law and crime
    ## 934                                                                                                                         Society, development/Law and crime
    ## 935                                                                                                                         Society, development/Law and crime
    ## 936                                                                                                                         Society, development/Law and crime
    ## 937                                                                                                                         Society, development/Law and crime
    ## 938                                                                                                                         Society, development/Law and crime
    ## 939                                                                                               Society, development/Millennium Development Goals Indicators
    ## 940                                                                                               Society, development/Millennium Development Goals Indicators
    ## 941                                                                                               Society, development/Millennium Development Goals Indicators
    ## 942                                                                                               Society, development/Millennium Development Goals Indicators
    ## 943                                                                                               Society, development/Millennium Development Goals Indicators
    ## 944                                                                                               Society, development/Millennium Development Goals Indicators
    ## 945                                                                                               Society, development/Millennium Development Goals Indicators
    ## 946                                                                                               Society, development/Millennium Development Goals Indicators
    ## 947                                                                                               Society, development/Millennium Development Goals Indicators
    ## 948                                                                                               Society, development/Millennium Development Goals Indicators
    ## 949                                                                                               Society, development/Millennium Development Goals Indicators
    ## 950                                                                                               Society, development/Millennium Development Goals Indicators
    ## 951                                                                                               Society, development/Millennium Development Goals Indicators
    ## 952                                                                                               Society, development/Millennium Development Goals Indicators
    ## 953                                                                                               Society, development/Millennium Development Goals Indicators
    ## 954                                                                                               Society, development/Millennium Development Goals Indicators
    ## 955                                                                                               Society, development/Millennium Development Goals Indicators
    ## 956                                                                                               Society, development/Millennium Development Goals Indicators
    ## 957                                                                                               Society, development/Millennium Development Goals Indicators
    ## 958                                                                                               Society, development/Millennium Development Goals Indicators
    ## 959                                                                                               Society, development/Millennium Development Goals Indicators
    ## 960                                                                                               Society, development/Millennium Development Goals Indicators
    ## 961                                                                                               Society, development/Millennium Development Goals Indicators
    ## 962                                                                                               Society, development/Millennium Development Goals Indicators
    ## 963                                                                                               Society, development/Millennium Development Goals Indicators
    ## 964                                                                                               Society, development/Millennium Development Goals Indicators
    ## 965                                                                                               Society, development/Millennium Development Goals Indicators
    ## 966                                                                                               Society, development/Millennium Development Goals Indicators
    ## 967                                                                                               Society, development/Millennium Development Goals Indicators
    ## 968                                                                                               Society, development/Millennium Development Goals Indicators
    ## 969                                                                                               Society, development/Millennium Development Goals Indicators
    ## 970                                                                                               Society, development/Millennium Development Goals Indicators
    ## 971                                                                                               Society, development/Millennium Development Goals Indicators
    ## 972                                                                                               Society, development/Millennium Development Goals Indicators
    ## 973                                                                                               Society, development/Millennium Development Goals Indicators
    ## 974                                                                                               Society, development/Millennium Development Goals Indicators
    ## 975                                                                                               Society, development/Millennium Development Goals Indicators
    ## 976                                                                                               Society, development/Millennium Development Goals Indicators
    ## 977                                                                                               Society, development/Millennium Development Goals Indicators
    ## 978                                                                                               Society, development/Millennium Development Goals Indicators
    ## 979                                                                                               Society, development/Millennium Development Goals Indicators
    ## 980                                                                                               Society, development/Millennium Development Goals Indicators
    ## 981                                                                                               Society, development/Millennium Development Goals Indicators
    ## 982                                                                                               Society, development/Millennium Development Goals Indicators
    ## 983                                                                                               Society, development/Millennium Development Goals Indicators
    ## 984                                                                                               Society, development/Millennium Development Goals Indicators
    ## 985                                                                                               Society, development/Millennium Development Goals Indicators
    ## 986                                                                                               Society, development/Millennium Development Goals Indicators
    ## 987                                                                                               Society, development/Millennium Development Goals Indicators
    ## 988                                                                                               Society, development/Millennium Development Goals Indicators
    ## 989                                                                                               Society, development/Millennium Development Goals Indicators
    ## 990                                                                                               Society, development/Millennium Development Goals Indicators
    ## 991                                                                                               Society, development/Millennium Development Goals Indicators
    ## 992                                                                                               Society, development/Millennium Development Goals Indicators
    ## 993                                                                                               Society, development/Millennium Development Goals Indicators
    ## 994                                                                                               Society, development/Millennium Development Goals Indicators
    ## 995                                                                                               Society, development/Millennium Development Goals Indicators
    ## 996                                                                                               Society, development/Millennium Development Goals Indicators
    ## 997                                                                                               Society, development/Millennium Development Goals Indicators
    ## 998                                                                                               Society, development/Millennium Development Goals Indicators
    ## 999                                                                                               Society, development/Millennium Development Goals Indicators
    ## 1000                                                                                              Society, development/Millennium Development Goals Indicators
    ## 1001                                                                                              Society, development/Millennium Development Goals Indicators
    ## 1002                                                                                              Society, development/Millennium Development Goals Indicators
    ## 1003                                                                                              Society, development/Millennium Development Goals Indicators
    ## 1004                                                                                              Society, development/Millennium Development Goals Indicators
    ## 1005                                                                                              Society, development/Millennium Development Goals Indicators
    ## 1006                                                                                              Society, development/Millennium Development Goals Indicators
    ## 1007                                                                                              Society, development/Millennium Development Goals Indicators
    ## 1008                                                                                              Society, development/Millennium Development Goals Indicators
    ## 1009                                                                                              Society, development/Millennium Development Goals Indicators
    ## 1010                                                                                              Society, development/Millennium Development Goals Indicators
    ## 1011                                                                                              Society, development/Millennium Development Goals Indicators
    ## 1012                                                                                              Society, development/Millennium Development Goals Indicators
    ## 1013                                                                                              Society, development/Millennium Development Goals Indicators
    ## 1014                                                                                              Society, development/Millennium Development Goals Indicators
    ## 1015                                                                                              Society, development/Millennium Development Goals Indicators
    ## 1016                                                                                              Society, development/Millennium Development Goals Indicators
    ## 1017                                                                                              Society, development/Millennium Development Goals Indicators
    ## 1018                                                                                              Society, development/Millennium Development Goals Indicators
    ## 1019                                                                                              Society, development/Millennium Development Goals Indicators
    ## 1020                                                                                                    Society, development/Monasteries, Temples and Churches
    ## 1021                                                                                                    Society, development/Monasteries, Temples and Churches
    ## 1022                                                                                                    Society, development/Monasteries, Temples and Churches
    ## 1023                                                                                    Society, development/Poverty, inequality and minimum subsistence level
    ## 1024                                                                                    Society, development/Poverty, inequality and minimum subsistence level
    ## 1025                                                                                    Society, development/Poverty, inequality and minimum subsistence level
    ## 1026                                                                                    Society, development/Poverty, inequality and minimum subsistence level
    ## 1027                                                                                    Society, development/Poverty, inequality and minimum subsistence level
    ## 1028                                                                                    Society, development/Poverty, inequality and minimum subsistence level
    ## 1029                                                                                    Society, development/Poverty, inequality and minimum subsistence level
    ## 1030                                                                                    Society, development/Poverty, inequality and minimum subsistence level
    ## 1031                                                                                    Society, development/Poverty, inequality and minimum subsistence level
    ## 1032                                                                                    Society, development/Poverty, inequality and minimum subsistence level
    ## 1033                                                                                    Society, development/Poverty, inequality and minimum subsistence level
    ## 1034                                                                                                         Society, development/Social Insurance and Welfare
    ## 1035                                                                                                         Society, development/Social Insurance and Welfare
    ## 1036                                                                                                         Society, development/Social Insurance and Welfare
    ## 1037                                                                                                         Society, development/Social Insurance and Welfare
    ## 1038                                                                                                         Society, development/Social Insurance and Welfare
    ## 1039                                                                                                         Society, development/Social Insurance and Welfare
    ## 1040                                                                                                         Society, development/Social Insurance and Welfare
    ## 1041                                                                                                         Society, development/Social Insurance and Welfare
    ## 1042                                                                                                         Society, development/Social Insurance and Welfare
    ## 1043                                                                                                         Society, development/Social Insurance and Welfare
    ## 1044                                                                                                         Society, development/Social Insurance and Welfare
    ## 1045                                                                                                         Society, development/Social Insurance and Welfare
    ## 1046                                                                                                         Society, development/Social Insurance and Welfare
    ## 1047                                                                                                         Society, development/Social Insurance and Welfare
    ## 1048                                                                                                         Society, development/Social Insurance and Welfare
    ## 1049                                                                                                         Society, development/Social Insurance and Welfare
    ## 1050                                                                                                         Society, development/Social Insurance and Welfare
    ## 1051                                                                                                         Society, development/Social Insurance and Welfare
    ## 1052                                                                                                         Society, development/Social Insurance and Welfare
    ## 1053                                                                                                         Society, development/Social Insurance and Welfare
    ## 1054                                                                                                         Society, development/Social Insurance and Welfare
    ## 1055                                                                                                         Society, development/Social Insurance and Welfare
    ## 1056                                                                                                         Society, development/Social Insurance and Welfare
    ## 1057                                                                                                         Society, development/Social Insurance and Welfare
    ## 1058                                                                                                         Society, development/Social Insurance and Welfare
    ## 1059                                                                                                         Society, development/Social Insurance and Welfare
    ## 1060                                                                                                        Society, development/Sustainable Development Goals
    ## 1061                                                                    Economy, environment/Money and Finance/MAIN INDICATORS OF INSURANCE SECTOR, by quarter
    ## 1062                                                                    Economy, environment/Money and Finance/MAIN INDICATORS OF INSURANCE SECTOR, by quarter
    ## 1063                                                                    Economy, environment/Money and Finance/MAIN INDICATORS OF INSURANCE SECTOR, by quarter
    ## 1064                                                                    Economy, environment/Money and Finance/MAIN INDICATORS OF INSURANCE SECTOR, by quarter
    ## 1065                                                                    Economy, environment/Money and Finance/MAIN INDICATORS OF INSURANCE SECTOR, by quarter
    ## 1066                                                                                 Economy, environment/Producer price index/INDUSTRIAL PRODUCER PRICE INDEX
    ## 1067                                                                                 Economy, environment/Producer price index/INDUSTRIAL PRODUCER PRICE INDEX
    ## 1068                                                                    Economy, environment/Producer price index/PRODUCER PRICE INDEX OF ACCOMMODATION SECTOR
    ## 1069                                                                    Economy, environment/Producer price index/PRODUCER PRICE INDEX OF ACCOMMODATION SECTOR
    ## 1070                                                                    Economy, environment/Producer price index/PRODUCER PRICE INDEX OF ACCOMMODATION SECTOR
    ## 1071                                                        Economy, environment/Producer price index/PRODUCER PRICE INDEX OF FOOD AND BEVERAGE SERVICE SECTOR
    ## 1072                                                        Economy, environment/Producer price index/PRODUCER PRICE INDEX OF FOOD AND BEVERAGE SERVICE SECTOR
    ## 1073                                                        Economy, environment/Producer price index/PRODUCER PRICE INDEX OF FOOD AND BEVERAGE SERVICE SECTOR
    ## 1074                                                    Economy, environment/Producer price index/PRODUCER PRICE INDEX OF INFORMATION AND COMMUNICATION SECTOR
    ## 1075                                                    Economy, environment/Producer price index/PRODUCER PRICE INDEX OF INFORMATION AND COMMUNICATION SECTOR
    ## 1076                                                    Economy, environment/Producer price index/PRODUCER PRICE INDEX OF INFORMATION AND COMMUNICATION SECTOR
    ## 1077                                                                   Economy, environment/Producer price index/PRODUCER PRICE INDEX OF TRANSPORTATION SECTOR
    ## 1078                                                                   Economy, environment/Producer price index/PRODUCER PRICE INDEX OF TRANSPORTATION SECTOR
    ## 1079                                                                   Economy, environment/Producer price index/PRODUCER PRICE INDEX OF TRANSPORTATION SECTOR
    ## 1080                                                                                     Education, health/Births, deaths/NUMBER OF MATERNAL DEATHS, by region
    ## 1081                                                                                     Education, health/Births, deaths/NUMBER OF MATERNAL DEATHS, by region
    ## 1082                                                                       Education, health/Main indicators for Health sector/NUMBER OF INPATIENTS, by region
    ## 1083                                                                       Education, health/Main indicators for Health sector/NUMBER OF INPATIENTS, by region
    ## 1084                                     Industry, service/Construction/CONSTRUCTION, CAPITAL REPAIRS PERFORMED BY DOMESTIC ENTERPRISES, by soum and district,
    ## 1085                                     Industry, service/Construction/CONSTRUCTION, CAPITAL REPAIRS PERFORMED BY DOMESTIC ENTERPRISES, by soum and district,
    ## 1086                                                                                          Industry, service/Intellectual property/CERTIFIED UTILITY MODELS
    ## 1087                                                                                          Industry, service/Intellectual property/CERTIFIED UTILITY MODELS
    ## 1088                                                                                       Industry, service/Intellectual property/COPYRIGHT, BY TYPES OF WORK
    ## 1089                                                                                       Industry, service/Intellectual property/COPYRIGHT, BY TYPES OF WORK
    ## 1090                                                                          Industry, service/Intellectual property/PATENT APPLICATIONS FOR INDUSTRAL DESIGN
    ## 1091                                                                          Industry, service/Intellectual property/PATENT APPLICATIONS FOR INDUSTRAL DESIGN
    ## 1092                                                                                 Industry, service/Intellectual property/PATENT APPLICATIONS FOR INVENTION
    ## 1093                                                                                 Industry, service/Intellectual property/PATENT APPLICATIONS FOR INVENTION
    ## 1094                                                                                                  Industry, service/Intellectual property/PATENTS IN FORCE
    ## 1095                                                                                                  Industry, service/Intellectual property/PATENTS IN FORCE
    ## 1096                                                                                                  Industry, service/Intellectual property/PATENTS IN FORCE
    ## 1097                                                                                  Industry, service/Intellectual property/THE WORKS PROTECTED BY COPYRIGHT
    ## 1098                                                                                  Industry, service/Intellectual property/THE WORKS PROTECTED BY COPYRIGHT
    ## 1099                                                                                  Industry, service/Intellectual property/TOTAL APPLICATIONS FOR TRADEMARK
    ## 1100                                                                                  Industry, service/Intellectual property/TOTAL APPLICATIONS FOR TRADEMARK
    ## 1101                                                                              Industry, service/Intellectual property/TOTAL APPLICATIONS FOR UTILITY MODEL
    ## 1102                                                                              Industry, service/Intellectual property/TOTAL APPLICATIONS FOR UTILITY MODEL
    ## 1103                                                                                               Industry, service/Intellectual property/TOTAL PATENT GRANTS
    ## 1104                                                                                               Industry, service/Intellectual property/TOTAL PATENT GRANTS
    ## 1105                                                                                                Industry, service/Intellectual property/TRADEMARK IN FORCE
    ## 1106                                                                                                Industry, service/Intellectual property/TRADEMARK IN FORCE
    ## 1107                                                                                            Industry, service/Intellectual property/TRADEMARK REGISTRATION
    ## 1108                                                                                            Industry, service/Intellectual property/TRADEMARK REGISTRATION
    ## 1109                                                                                           Industry, service/Intellectual property/UTILITY MODELS IN FORCE
    ## 1110                                                                                           Industry, service/Intellectual property/UTILITY MODELS IN FORCE
    ## 1111                                           Industry, service/Telecommunication/KEY INDICATORS OF COMMUNICATION SERVICES, by region, aimags and the Capital
    ## 1112                                           Industry, service/Telecommunication/KEY INDICATORS OF COMMUNICATION SERVICES, by region, aimags and the Capital
    ## 1113                                                   Industry, service/Telecommunication/NUMBER OF CABLE TELEVISION USERS, by region, aimags and the Capital
    ## 1114                                                   Industry, service/Telecommunication/NUMBER OF CABLE TELEVISION USERS, by region, aimags and the Capital
    ## 1115                                             Industry, service/Telecommunication/NUMBER OF INTERNET USERS AND COMPUTERS, by region, aimags and the Capital
    ## 1116                                             Industry, service/Telecommunication/NUMBER OF INTERNET USERS AND COMPUTERS, by region, aimags and the Capital
    ## 1117                                                                                   Industry, service/Telecommunication/POSTAL SERVICE INDICATORS, by types
    ## 1118                                                                                   Industry, service/Telecommunication/POSTAL SERVICE INDICATORS, by types
    ## 1119                                 Industry, service/Telecommunication/REVENUE OF COMMUNICATION SECTOR, by type of operation, region, aimags and the Capital
    ## 1120                                 Industry, service/Telecommunication/REVENUE OF COMMUNICATION SECTOR, by type of operation, region, aimags and the Capital
    ## 1121                                                                      Industry, service/Tourism/INBOUND AND OUTBOUND PASSENGERS by Name of border crossing
    ## 1122                                                                      Industry, service/Tourism/INBOUND AND OUTBOUND PASSENGERS by Name of border crossing
    ## 1123                                                                      Industry, service/Tourism/INBOUND AND OUTBOUND PASSENGERS by Name of border crossing
    ## 1124                                                          Industry, service/Tourism/Number of inbound and outbound foreign passengers by country of origin
    ## 1125                                                          Industry, service/Tourism/Number of inbound and outbound foreign passengers by country of origin
    ## 1126                                                          Industry, service/Tourism/Number of inbound and outbound foreign passengers by country of origin
    ## 1127                                                           Industry, service/Tourism/NUMBER OF INBOUND PASSENGERS by border crossings and purpose of visit
    ## 1128                                                           Industry, service/Tourism/NUMBER OF INBOUND PASSENGERS by border crossings and purpose of visit
    ## 1129                                                           Industry, service/Tourism/NUMBER OF INBOUND PASSENGERS by border crossings and purpose of visit
    ## 1130                                                                                           Industry, service/Tourism/NUMBER OF INBOUND TOURISTS by country
    ## 1131                                                                                           Industry, service/Tourism/NUMBER OF INBOUND TOURISTS by country
    ## 1132                                                                                           Industry, service/Tourism/NUMBER OF INBOUND TOURISTS by country
    ## 1133                                                          Industry, service/Tourism/NUMBER OF OUTBOUND MONGOLIAN, by border crossings and purpose of visit
    ## 1134                                                          Industry, service/Tourism/NUMBER OF OUTBOUND MONGOLIAN, by border crossings and purpose of visit
    ## 1135                                                        Industry, service/Trade, hotel and restaurant/INCOME OF THE FOOD SECTOR, by Aimag and Capital City
    ## 1136                                                        Industry, service/Trade, hotel and restaurant/INCOME OF THE FOOD SECTOR, by Aimag and Capital City
    ## 1137                                                       Industry, service/Trade, hotel and restaurant/INCOME OF THE HOTEL SECTOR, by Aimag and Capital City
    ## 1138                                                       Industry, service/Trade, hotel and restaurant/INCOME OF THE HOTEL SECTOR, by Aimag and Capital City
    ## 1139                                               Industry, service/Transportation/CARRIED PASSENGERS, by air transport, by each direction and national level
    ## 1140                                               Industry, service/Transportation/CARRIED PASSENGERS, by air transport, by each direction and national level
    ## 1141                                               Industry, service/Transportation/CARRIED PASSENGERS, by air transport, by each direction and national level
    ## 1142                                                                       Industry, service/Transportation/KEY INDICATORS OF AIR TRANSPORT, by national level
    ## 1143                                                                       Industry, service/Transportation/KEY INDICATORS OF AIR TRANSPORT, by national level
    ## 1144                                                                       Industry, service/Transportation/KEY INDICATORS OF AIR TRANSPORT, by national level
    ## 1145                                                                      Industry, service/Transportation/KEY INDICATORS OF AUTO TRANSPORT, by national level
    ## 1146                                                                      Industry, service/Transportation/KEY INDICATORS OF AUTO TRANSPORT, by national level
    ## 1147                                                                   Industry, service/Transportation/KEY INDICATORS OF RAILWAY TRANSPORT, by national level
    ## 1148                                                                   Industry, service/Transportation/KEY INDICATORS OF RAILWAY TRANSPORT, by national level
    ## 1149                                                                   Industry, service/Transportation/KEY INDICATORS OF RAILWAY TRANSPORT, by national level
    ## 1150                                                                       Labour, business/Labour/EMPLOYEES WORKING ABROAD ON A CONTRACTUAL BASIS, by country
    ## 1151                                                                       Labour, business/Labour/EMPLOYEES WORKING ABROAD ON A CONTRACTUAL BASIS, by country
    ## 1152                                                           Labour, business/Labour/EMPLOYMENT INDICATORS OF POPULATION AGED 15 AND OVER, by national level
    ## 1153                                                           Labour, business/Labour/EMPLOYMENT INDICATORS OF POPULATION AGED 15 AND OVER, by national level
    ## 1154                                                         Labour, business/Labour/EMPLOYMENT TO POPULATION RATIO, by sex, age group, aimags and the Capital
    ## 1155                                                         Labour, business/Labour/EMPLOYMENT TO POPULATION RATIO, by sex, age group, aimags and the Capital
    ## 1156                                                        Labour, business/Labour/EMPLOYMENT, by economic activities, sex, age group, aimags and the Capital
    ## 1157                                                        Labour, business/Labour/EMPLOYMENT, by economic activities, sex, age group, aimags and the Capital
    ## 1158                                                         Labour, business/Labour/EMPLOYMENT, by occupation, sex, age group, region, aimags and the Capital
    ## 1159                                                         Labour, business/Labour/EMPLOYMENT, by occupation, sex, age group, region, aimags and the Capital
    ## 1160                                        Labour, business/Labour/EMPLOYMENT, by status in employment, age group, region, aimags and the Capital,  1985-2018
    ## 1161                                        Labour, business/Labour/EMPLOYMENT, by status in employment, age group, region, aimags and the Capital,  1985-2018
    ## 1162                                   Labour, business/Labour/EMPLOYMENT, by status in employment, sex, age group, region, aimags and the Capital, since 2019
    ## 1163                                   Labour, business/Labour/EMPLOYMENT, by status in employment, sex, age group, region, aimags and the Capital, since 2019
    ## 1164                                                                                           Labour, business/Labour/INJURED PERSONS, by economic activities
    ## 1165                                                                                           Labour, business/Labour/INJURED PERSONS, by economic activities
    ## 1166                                                                        Labour, business/Labour/INJURED PERSONS, by economic activities, type of accidents
    ## 1167                                                                        Labour, business/Labour/INJURED PERSONS, by economic activities, type of accidents
    ## 1168                                                        Labour, business/Labour/LABOUR FORCE PARTICIPATION RATE, by sex, age group, aimags and the Capital
    ## 1169                                                        Labour, business/Labour/LABOUR FORCE PARTICIPATION RATE, by sex, age group, aimags and the Capital
    ## 1170                                                                           Labour, business/Labour/LABOUR FORCE, by sex, age group, aimags and the Capital
    ## 1171                                                                           Labour, business/Labour/LABOUR FORCE, by sex, age group, aimags and the Capital
    ## 1172                                                           Labour, business/Labour/LABOUR UNDERUTILIZATION RATE, by sex, age group, aimags and the Capital
    ## 1173                                                           Labour, business/Labour/LABOUR UNDERUTILIZATION RATE, by sex, age group, aimags and the Capital
    ## 1174                                                                Labour, business/Labour/LABOUR UNDERUTILIZATION, by sex, age group, aimags and the Capital
    ## 1175                                                                Labour, business/Labour/LABOUR UNDERUTILIZATION, by sex, age group, aimags and the Capital
    ## 1176                                                        Labour, business/Labour/OCCUPATIONAL ACCIDENT, ACUTE POISONINGS, by region, aimags and the Capital
    ## 1177                                                        Labour, business/Labour/OCCUPATIONAL ACCIDENT, ACUTE POISONINGS, by region, aimags and the Capital
    ## 1178                                            Labour, business/Labour/PERSONS OUTSIDE THE LABOUR FORCE, by reason, by sex, age group, aimags and the Capital
    ## 1179                                            Labour, business/Labour/PERSONS OUTSIDE THE LABOUR FORCE, by reason, by sex, age group, aimags and the Capital
    ## 1180                                                                     Labour, business/Labour/UNEMPLOYED, by reason, sex, age group, aimags and the Capital
    ## 1181                                                                     Labour, business/Labour/UNEMPLOYED, by reason, sex, age group, aimags and the Capital
    ## 1182                                                                                    Labour, business/Wages/EMPLOYEES, by group of wages,and share to total
    ## 1183                                                                                    Labour, business/Wages/EMPLOYEES, by group of wages,and share to total
    ## 1184                                                                         Labour, business/Wages/MONTHLY AVERAGE NOMINAL WAGES , by legal status and gender
    ## 1185                                                                         Labour, business/Wages/MONTHLY AVERAGE NOMINAL WAGES , by legal status and gender
    ## 1186                                                                    Labour, business/Wages/MONTHLY AVERAGE NOMINAL WAGES , by type of ownership and gender
    ## 1187                                                                    Labour, business/Wages/MONTHLY AVERAGE NOMINAL WAGES , by type of ownership and gender
    ## 1188                                                      Labour, business/Wages/MONTHLY AVERAGE NOMINAL WAGES OF EMPLOYEE, by employees size class and gender
    ## 1189                                                      Labour, business/Wages/MONTHLY AVERAGE NOMINAL WAGES OF EMPLOYEE, by employees size class and gender
    ## 1190                                                                  Labour, business/Wages/MONTHLY AVERAGE NOMINAL WAGES, by division of economic activities
    ## 1191                                                                  Labour, business/Wages/MONTHLY AVERAGE NOMINAL WAGES, by division of economic activities
    ## 1192                                                                            Labour, business/Wages/MONTHLY AVERAGE NOMINAL WAGES, by occupation and gender
    ## 1193                                                                            Labour, business/Wages/MONTHLY AVERAGE NOMINAL WAGES, by occupation and gender
    ## 1194                                                        Labour, business/Wages/MONTHLY AVERAGE NOMINAL WAGES, by region, aimags and the Capital, by gender
    ## 1195                                                        Labour, business/Wages/MONTHLY AVERAGE NOMINAL WAGES, by region, aimags and the Capital, by gender
    ## 1196                                                                                                  Labour, business/Wages/MONTHLY MEDIAN WAGES OF EMPLOYEES
    ## 1197                                                                                                  Labour, business/Wages/MONTHLY MEDIAN WAGES OF EMPLOYEES
    ## 1198                                                                    Labour, business/Wages/REAL WAGE INDEX (2015=100), by divisions of economic activities
    ## 1199                                                                    Labour, business/Wages/REAL WAGE INDEX (2015=100), by divisions of economic activities
    ## 1200                                                   Society, development/Law and crime/CRIME CAUSED OF DAMAGES AND DAMAGES WERE RESTITUTED,  year and month
    ## 1201                                                   Society, development/Law and crime/CRIME CAUSED OF DAMAGES AND DAMAGES WERE RESTITUTED,  year and month
    ## 1202                             Society, development/Law and crime/NUMBER OF CRIMINAL CASES REGISTERED BY THE ANTI-CORRUPTION AGENCY, by Type, Month and Year
    ## 1203                             Society, development/Law and crime/NUMBER OF CRIMINAL CASES REGISTERED BY THE ANTI-CORRUPTION AGENCY, by Type, Month and Year
    ## 1204                                Society, development/Law and crime/NUMBER OF OFFENDERS, by region, aimag and the capital, sex , age group and month,  year
    ## 1205                                Society, development/Law and crime/NUMBER OF OFFENDERS, by region, aimag and the capital, sex , age group and month,  year
    ## 1206                                                           Society, development/Law and crime/NUMBER OF RECORDED CRIMES, by classification, year and month
    ## 1207                                                           Society, development/Law and crime/NUMBER OF RECORDED CRIMES, by classification, year and month
    ## 1208                                                      Society, development/Law and crime/NUMBER OF RECORDED CRIMES, by region, aimag and the capital, year
    ## 1209                                                      Society, development/Law and crime/NUMBER OF RECORDED CRIMES, by region, aimag and the capital, year
    ## 1210                                                                     Society, development/Law and crime/RECORDED CRIMES, by classification, year and month
    ## 1211                                                                     Society, development/Law and crime/RECORDED CRIMES, by classification, year and month
    ## 1212                                                          Society, development/Social Insurance and Welfare/EXPENDITURE OF SOCIAL SINSURANCE FUND, by type
    ## 1213                                                          Society, development/Social Insurance and Welfare/EXPENDITURE OF SOCIAL SINSURANCE FUND, by type
    ## 1214 Society, development/Social Insurance and Welfare/NUMBER OF PENSIONARIES, WHO RECEIPT PENSIONS FROM THE SOCIAL INSURANCE FUND, by type of pension, annual
    ## 1215 Society, development/Social Insurance and Welfare/NUMBER OF PENSIONARIES, WHO RECEIPT PENSIONS FROM THE SOCIAL INSURANCE FUND, by type of pension, annual
    ## 1216                                                     Society, development/Social Insurance and Welfare/PERSONS INVOLVED SOCIAL WELFARE ACTIVITIES, by type
    ## 1217                                                     Society, development/Social Insurance and Welfare/PERSONS INVOLVED SOCIAL WELFARE ACTIVITIES, by type
    ## 1218                                                               Society, development/Social Insurance and Welfare/REVENUE OF SOCIAL INSURANCE FUND, by type
    ## 1219                                                               Society, development/Social Insurance and Welfare/REVENUE OF SOCIAL INSURANCE FUND, by type
    ## 1220                                                                         Society, development/Social Insurance and Welfare/THE NUMBER OF INSURERS, by type
    ## 1221                                                                         Society, development/Social Insurance and Welfare/THE NUMBER OF INSURERS, by type
    ## 1222            Society, development/Social Insurance and Welfare/TOTAL AMOUNT OF GRANTED PENSIONS AND BENEFITS, SERVICES IN SOCIAL WELFARE ACTIVITES, by type
    ## 1223            Society, development/Social Insurance and Welfare/TOTAL AMOUNT OF GRANTED PENSIONS AND BENEFITS, SERVICES IN SOCIAL WELFARE ACTIVITES, by type
    ## 1224                                            Society, development/Social Insurance and Welfare/WHO RECEIPT PENSIONS FROM THE SOCIAL INSURANCE FUND, by type
    ## 1225                                            Society, development/Social Insurance and Welfare/WHO RECEIPT PENSIONS FROM THE SOCIAL INSURANCE FUND, by type

``` r
nso_offline_disable()
```

## Tips

- Use caching during development to avoid repeated PXWeb metadata hits.
- Keep examples small and guard network calls when knitting documents
  ([`curl::has_internet()`](https://jeroen.r-universe.dev/curl/reference/nslookup.html)).
- For reproducibility, store your selections and results; cache is a
  convenience, not a persistence layer.
