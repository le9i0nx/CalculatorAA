-- Use forein keys support
PRAGMA foreign_keys = ON;

-- Drop data first
DROP INDEX IF EXISTS "INSTRUMENTS_SINCE";
DROP INDEX IF EXISTS "DATA_DATE";

DROP TABLE IF EXISTS "INSTRUMENTS";
DROP TABLE IF EXISTS "DOWNLOADERS";
DROP TABLE IF EXISTS "DATA";

-- Create tables
CREATE TABLE "INSTRUMENTS" (
	"ID"            INTEGER     PRIMARY KEY     NOT NULL,
	"TICKER"        TEXT                        NOT NULL    UNIQUE
	                                                            ON CONFLICT ABORT,
    "NAME"          TEXT                        NOT NULL,
    "TYPE"          TEXT                        NOT NULL,
	"DOWNLOADER"    INTEGER                     NOT NULL    REFERENCES "DOWNLOADERS" ("ID")
	                                                            ON DELETE RESTRICT
	                                                            ON UPDATE CASCADE,
	"SINCE"         TEXT,
	"UPDATED"       TEXT
);

CREATE TABLE "DOWNLOADERS" (
	"ID"            INTEGER     PRIMARY KEY     NOT NULL,
	"NAME"          TEXT                        NOT NULL,
	"URI"           TEXT                        NOT NULL
);

CREATE TABLE "DATA" (
	"ID"            INTEGER     PRIMARY KEY     NOT NULL,
	"INSTRUMENT"    INTEGER                     NOT NULL    REFERENCES "INSTRUMENTS" ("ID")
	                                                            ON DELETE CASCADE
	                                                            ON UPDATE CASCADE,
	"DATE"          TEXT                        NOT NULL,
	"OPEN"          REAL                        NOT NULL,
	"HIGH"          REAL                        NOT NULL,
	"LOW"           REAL                        NOT NULL,
	"CLOSE"         REAL                        NOT NULL,
	"CLOSEADJ"      REAL                        NOT NULL,
	"VOLUME"        REAL                        NOT NULL
);

-- Create indexes
CREATE INDEX "INSTRUMENTS_DOWNLOADER" ON "INSTRUMENTS" ("DOWNLOADER");
CREATE INDEX "INSTRUMENTS_SINCE" ON "INSTRUMENTS" ("SINCE");
CREATE INDEX "DATA_INSTRUMENT" ON "DATA" ("INSTRUMENT");
CREATE INDEX "DATA_DATE" ON "DATA" ("DATE");

-- Create data
-- Create downloaders
INSERT INTO "DOWNLOADERS" VALUES (1, 'Yahoo Finance', 'https://finance.yahoo.com/');
INSERT INTO "DOWNLOADERS" VALUES (2, 'Moscow Exchange', 'http://moex.com/');

-- Create instruments
INSERT INTO "INSTRUMENTS" VALUES
    (NULL, 'SPY', 'SPDR S&P 500 ETF', 'ETF', 1, '1993-01-29', NULL),
    (NULL, 'IVV', 'iShares Core S&P 500 ETF', 'ETF', 1, '2000-05-19', NULL),
    (NULL, 'VTI', 'Vanguard Total Stock Market ETF', 'ETF', 1, '2001-06-15', NULL),
    (NULL, 'EFA', 'iShares MSCI EAFE ETF', 'ETF', 1, '2001-08-27', NULL),
    (NULL, 'VOO', 'Vanguard S&P 500 ETF', 'ETF', 1, '2010-09-09', NULL),
    (NULL, 'VWO', 'Vanguard FTSE Emerging Markets ETF', 'ETF', 1, '2005-03-10', NULL),
    (NULL, 'VEA', 'Vanguard FTSE Developed Markets ETF', 'ETF', 1, '2007-07-26', NULL),
    (NULL, 'QQQ', 'PowerShares QQQ ETF', 'ETF', 1, '1999-03-10', NULL),
    (NULL, 'IWM', 'iShares Russell 2000 ETF', 'ETF', 1, '2000-05-26', NULL),
    (NULL, 'IJH', 'iShares Core S&P Mid-Cap ETF', 'ETF', 1, '2000-05-26', NULL),
    (NULL, 'IWD', 'iShares Russell 1000 Value ETF', 'ETF', 1, '2000-05-26', NULL),
    (NULL, 'IWF', 'iShares Russell 1000 Growth ETF', 'ETF', 1, '2000-05-26', NULL),
    (NULL, 'EEM', 'iShares MSCI Emerging Markets ETF', 'ETF', 1, '2003-04-14', NULL),
    (NULL, 'VTV', 'Vanguard Value ETF', 'ETF', 1, '2004-01-30', NULL),
    (NULL, 'IJR', 'iShares Core S&P Small-Cap ETF', 'ETF', 1, '2000-05-26', NULL),
    (NULL, 'XLF', 'Financial Select Sector SPDR Fund', 'ETF', 1, '1998-12-22', NULL),
    (NULL, 'VUG', 'Vanguard Growth ETF', 'ETF', 1, '2004-01-30', NULL),
    (NULL, 'VIG', 'Vanguard Dividend Appreciation ETF', 'ETF', 1, '2006-05-02', NULL),
    (NULL, 'MDY', 'SPDR S&P MIDCAP 400 ETF', 'ETF', 1, '1995-08-18', NULL),
    (NULL, 'IEMG', 'iShares Core MSCI Emerging Markets ETF', 'ETF', 1, '2012-10-24', NULL),
    (NULL, 'XLE', 'Energy Select Sector SPDR Fund', 'ETF', 1, '1998-12-22', NULL),
    (NULL, 'VYM', 'Vanguard High Dividend Yield ETF', 'ETF', 1, '2006-11-16', NULL),
    (NULL, 'DVY', 'iShares Select Dividend ETF', 'ETF', 1, '2003-11-07', NULL),
    (NULL, 'IWB', 'iShares Russell 1000 ETF', 'ETF', 1, '2000-05-19', NULL),
    (NULL, 'VO', 'Vanguard Mid-Cap ETF', 'ETF', 1, '2004-01-30', NULL),
    (NULL, 'VB', 'Vanguard Small-Cap ETF', 'ETF', 1, '2004-01-30', NULL),
    (NULL, 'SDY', 'SPDR S&P Dividend ETF', 'ETF', 1, '2005-11-15', NULL),
    (NULL, 'EWJ', 'iShares MSCI Japan ETF', 'ETF', 1, '1996-03-18', NULL),
    (NULL, 'IVW', 'iShares S&P 500 Growth ETF', 'ETF', 1, '2000-05-26', NULL),
    (NULL, 'IEFA', 'iShares Core MSCI EAFE ETF', 'ETF', 1, '2012-10-24', NULL),
    (NULL, 'VEU', 'Vanguard FTSE All-World ex-US ETF', 'ETF', 1, '2007-03-08', NULL),
    (NULL, 'IWR', 'iShares Russell Mid-Cap ETF', 'ETF', 1, '2001-08-27', NULL),
    (NULL, 'DIA', 'SPDR Dow Jones® Industrial Average ETF', 'ETF', 1, '1998-01-20', NULL),
    (NULL, 'XLV', 'Health Care Select Sector SPDR Fund', 'ETF', 1, '1998-12-22', NULL),
    (NULL, 'XLK', 'Technology Select Sector SPDR Fund', 'ETF', 1, '1998-12-22', NULL),
    (NULL, 'USMV', 'iShares Edge MSCI Min Vol USA ETF', 'ETF', 1, '2011-10-20', NULL),
    (NULL, 'IVE', 'iShares S&P 500 Value ETF', 'ETF', 1, '2000-05-26', NULL),
    (NULL, 'RSP', 'Guggenheim S&P 500® Equal Weight ETF', 'ETF', 1, '2003-05-01', NULL),
    (NULL, 'XLY', 'Consumer Discretionary Select Sector SPDR Fund', 'ETF', 1, '1998-12-22', NULL),
    (NULL, 'XLI', 'Industrial Select Sector SPDR Fund', 'ETF', 1, '1998-12-22', NULL),
    (NULL, 'VGK', 'Vanguard FTSE Europe ETF', 'ETF', 1, '2005-03-10', NULL),
    (NULL, 'VGT', 'Vanguard Information Technology ETF', 'ETF', 1, '2004-01-30', NULL),
    (NULL, 'AGG', 'iShares Core U.S. Aggregate Bond ETF', 'ETF', 1, '2003-09-29', NULL),
    (NULL, 'BND', 'Total Bond Market ETF', 'ETF', 1, '2007-04-10', NULL),
    (NULL, 'LQD', 'iShares iBoxx', 'ETF', 1, '2002-07-30', NULL),
    (NULL, 'TIP', 'iShares TIPS Bond ETF', 'ETF', 1, '2003-12-05', NULL),
    (NULL, 'BSV', 'Short-Term Bond ETF', 'ETF', 1, '2007-04-10', NULL),
    (NULL, 'HYG', 'iShares iBoxx', 'ETF', 1, '2007-04-11', NULL),
    (NULL, 'VCSH', 'Vanguard Short-Term Corporate Bond ETF', 'ETF', 1, '2009-11-23', NULL),
    (NULL, 'JNK', 'SPDR Barclays Capital High Yield Bond ETF', 'ETF', 1, '2007-12-04', NULL),
    (NULL, 'CSJ', 'iShares 1-3 Year Credit Bond ETF', 'ETF', 1, '2007-01-11', NULL),
    (NULL, 'BIV', 'Intermediate-Term Bond ETF', 'ETF', 1, '2007-04-10', NULL),
    (NULL, 'SHY', 'iShares 1-3 Year Treasury Bond ETF', 'ETF', 1, '2002-07-30', NULL),
    (NULL, 'VCIT', 'Vanguard Intermediate-Term Corporate Bond ETF', 'ETF', 1, '2009-11-23', NULL),
    (NULL, 'GLD', 'SPDR Gold Shares ETF', 'ETF', 1, '2004-11-18', NULL),
    (NULL, 'IAU', 'iShares Gold Trust ETF', 'ETF', 1, '2005-01-28', NULL),
    (NULL, 'SLV', 'iShares Silver Trust ETF', 'ETF', 1, '2006-04-28', NULL),
    (NULL, 'USO', 'United States Oil Fund', 'ETF', 1, '2006-04-10', NULL),
    (NULL, 'DBC', 'PowerShares DB Commodity Index Tracking Fund', 'ETF', 1, '2006-02-06', NULL),
    (NULL, 'UCO', 'ProShares Ultra Bloomberg Crude Oil', 'ETF', 1, '2008-11-25', NULL),
    (NULL, 'GSG', 'iShares S&P GSCI Commodity-Indexed Trust ETF', 'ETF', 1, '2006-07-21', NULL),
    (NULL, 'VNQ', 'Vanguard REIT ETF', 'ETF', 1, '2004-09-29', NULL),
    (NULL, 'IYR', 'iShares U.S. Real Estate ETF', 'ETF', 1, '2000-06-19', NULL),
    (NULL, 'RWX', 'SPDR Dow Jones International Real Estate ETF', 'ETF', 1, '2006-12-19', NULL),
    (NULL, 'ICF', 'iShares Cohen & Steers REIT ETF', 'ETF', 1, '2001-02-02', NULL),
    (NULL, 'RWR', 'SPDR Dow Jones REIT ETF', 'ETF', 1, '2001-08-27', NULL),
    (NULL, 'VNQI', 'Vanguard Global ex-U.S. Real Estate ETF', 'ETF', 1, '2010-11-01', NULL),
    (NULL, 'SCHH', 'Schwab U.S. REIT ETF', 'ETF', 1, '2011-01-13', NULL),
    (NULL, 'XLRE', 'Real Estate Select Sector SPDR Fund', 'ETF', 1, '2015-10-08', NULL),
    (NULL, 'RWO', 'SPDR Dow Jones Global Real Estate ETF', 'ETF', 1, '2008-05-22', NULL),
    (NULL, 'REM', 'iShares Mortgage Real Estate Capped ETF', 'ETF', 1, '2007-05-04', NULL),
    (NULL, 'SCRYX', 'AB Sm Cp Core', 'FUND', 1, '2015-12-29', NULL),
    (NULL, 'JSMGX', 'Janus Triton', 'FUND', 1, '2005-11-30', NULL),
    (NULL, 'HFMIX', 'Hartfd:MidCap', 'FUND', 1, '2009-02-27', NULL),
    (NULL, 'JGMAX', 'Janus Triton', 'FUND', 1, '2005-08-04', NULL),
    (NULL, 'BCSSX', 'Brown Cap Sm Co', 'FUND', 1, '2011-12-15', NULL),
    (NULL, 'JMGRX', 'Janus Enterprise', 'FUND', 1, '2005-11-30', NULL),
    (NULL, 'JDMAX', 'Janus Enterprise', 'FUND', 1, '2005-01-25', NULL),
    (NULL, 'ETAGX', 'Eventide Gilead', 'FUND', 1, '2009-10-28', NULL),
    (NULL, 'FGROX', 'Emerald:Growth', 'FUND', 1, '2008-10-20', NULL),
    (NULL, 'BPTIX', 'Baron Partners Fund', 'FUND', 1, '2009-05-29', NULL),
    (NULL, 'JDMNX', 'Janus Enterprise', 'FUND', 1, '2012-07-12', NULL),
    (NULL, 'FMAGX', 'Fidelity Magellan Fund', 'FUND', 1, '1980-01-02', NULL),
    (NULL, 'JLGRX', 'JPMorgan:LgCp Gro', 'FUND', 1, '2009-04-14', NULL),
    (NULL, 'FUNYX', 'Pioneer Fndmntl Gro', 'FUND', 1, '2009-04-07', NULL),
    (NULL, 'PMCPX', 'Principal:MidCap', 'FUND', 1, '2010-09-27', NULL),
    (NULL, 'JGMNX', 'Janus Triton', 'FUND', 1, '2012-05-31', NULL),
    (NULL, 'IMIDX', 'Congress MC Gro', 'FUND', 1, '2012-11-01', NULL),
    (NULL, 'RNGGX', 'American Funds NEco', 'FUND', 1, '2009-05-01', NULL),
    (NULL, 'AKRIX', 'Akre Focus Fund', 'FUND', 1, '2009-08-31', NULL),
    (NULL, 'FAMGX', 'Fidelity Adv Srs Opp Ins', 'FUND', 1, '2012-12-11', NULL),
    (NULL, 'FWWEX', 'Fidelity Srs Opp Ins', 'FUND', 1, '2012-12-11', NULL),
    (NULL, 'RGAGX', 'American Funds Gro', 'FUND', 1, '2009-05-01', NULL),
    (NULL, 'BARIX', 'Baron Asset Fund', 'FUND', 1, '2009-05-29', NULL),
    (NULL, 'FVWSX', 'Fidelity Srs Opp Ins', 'FUND', 1, '2012-12-11', NULL),
    (NULL, 'AMOMX', 'AQR:Lg Cap Mom Style', 'FUND', 1, '2009-07-09', NULL),
    (NULL, 'TRMIX', 'T Rowe Price MC Vl', 'FUND', 1, '2015-09-08', NULL),
    (NULL, 'VSIAX', 'Vanguard SC Val Idx', 'FUND', 1, '2011-09-27', NULL),
    (NULL, 'XSLV', 'PowerShares S&P SmCp LV', 'FUND', 1, '2013-02-15', NULL),
    (NULL, 'VMVAX', 'Vanguard MC Val Idx', 'FUND', 1, '2011-09-27', NULL),
    (NULL, 'BOSVX', 'Bridgeway:Omni SCV', 'FUND', 1, '2011-08-31', NULL),
    (NULL, 'BWLYX', 'Am Beacon:BW LC Val', 'FUND', 1, '2012-02-06', NULL),
    (NULL, 'BWLIX', 'Am Beacon:BW LC Val', 'FUND', 1, '2012-02-06', NULL),
    (NULL, 'LVMIX', 'Lord Abbett Cal MCV', 'FUND', 1, '2011-12-22', NULL),
    (NULL, 'DSEEX', 'DoubleLine:Sh Enh CAPE', 'FUND', 1, '2013-11-01', NULL),
    (NULL, 'ESPNX', 'WellsFargo:Spec SCV', 'FUND', 1, '2010-07-30', NULL),
    (NULL, 'JDVWX', 'J Hancock III:Ds Val', 'FUND', 1, '2011-08-31', NULL),
    (NULL, 'JLVMX', 'JPMorgan:LgCp Val', 'FUND', 1, '2010-11-30', NULL),
    (NULL, 'TWQZX', 'Transam:Large Cp Val', 'FUND', 1, '2010-11-16', NULL),
    (NULL, 'JDVNX', 'J Hancock III:Ds Val', 'FUND', 1, '2014-06-11', NULL),
    (NULL, 'GIFFX', 'Invesco Gr & Income', 'FUND', 1, '2012-09-24', NULL),
    (NULL, 'WSCVX', 'Walthausen:SC Value', 'FUND', 1, '2008-02-01', NULL),
    (NULL, 'LBISX', 'LM BW Diversified LCV', 'FUND', 1, '2010-09-07', NULL),
    (NULL, 'ACSHX', 'Invesco Comstock', 'FUND', 1, '2010-06-01', NULL),
    (NULL, 'AMDVX', 'Amer Cent:MC Val', 'FUND', 1, '2013-07-26', NULL),
    (NULL, 'ACGQX', 'Invesco Gr & Income', 'FUND', 1, '2010-06-01', NULL),
    (NULL, 'FRGEX', 'Fidelity Srs Stk S LCV', 'FUND', 1, '2012-12-10', NULL),
    (NULL, 'FMMLX', 'Fidelity Adv Srs SS LCV', 'FUND', 1, '2012-12-10', NULL),
    (NULL, 'LCEFX', 'Invesco Dvsfd Div', 'FUND', 1, '2012-09-24', NULL),
    (NULL, 'FBLEX', 'Fidelity Srs Stk S LCV', 'FUND', 1, '2012-12-10', NULL),
    (NULL, 'ICSFX', 'Invesco Comstock', 'FUND', 1, '2012-09-24', NULL),
    (NULL, 'PRVIX', 'T Rowe Price SC Val', 'FUND', 1, '2015-08-28', NULL),
    (NULL, 'VSEMX', 'Vanguard Ext Mk Id', 'FUND', 1, '2016-03-29', NULL),
    (NULL, 'FLCPX', 'Fidelity SAI US LC Idx', 'FUND', 1, '2016-02-12', NULL),
    (NULL, 'MVSSX', 'Victory:Integrity SCV', 'FUND', 1, '2012-06-01', NULL),
    (NULL, 'JVMRX', 'J Hancock III:DVMC', 'FUND', 1, '2011-08-31', NULL),
    (NULL, 'ARAIX', 'Ariel:Fund', 'FUND', 1, '2011-12-30', NULL),
    (NULL, 'LYRIX', 'Lyrical US Val Eqty', 'FUND', 1, '2013-02-04', NULL),
    (NULL, 'BIAUX', 'Brown Adv SC FV', 'FUND', 1, '2009-01-02', NULL),
    (NULL, 'VSENX', 'JPMorgan:SmCp Eqty', 'FUND', 1, '2016-05-31', NULL),
    (NULL, 'DHMYX', 'Diamond Hill S/Md Cp', 'FUND', 1, '2011-12-30', NULL),
    (NULL, 'FSOFX', 'Fidelity Srs Sm Cap Op', 'FUND', 1, '2009-06-26', NULL),
    (NULL, 'CPXRX', 'Columbia:MdCp Index', 'FUND', 1, '2012-11-09', NULL),
    (NULL, 'OTIIX', 'T Rowe Price SC Stk', 'FUND', 1, '2015-08-28', NULL),
    (NULL, 'COFRX', 'Columbia:Cntr Core', 'FUND', 1, '2012-11-09', NULL),
    (NULL, 'FSSVX', 'Fidelity SmCp Id', 'FUND', 1, '2011-09-09', NULL),
    (NULL, 'SCHA', 'Schwab Str:US Sm Cap ETF', 'FUND', 1, '2009-11-03', NULL),
    (NULL, 'RAFGX', 'American Funds AMCP', 'FUND', 1, '2009-05-01', NULL),
    (NULL, 'XMLV', 'PowerShares S&P MidCp LV', 'FUND', 1, '2013-02-15', NULL),
    (NULL, 'FSKAX', 'Fidelity Tot Mk', 'FUND', 1, '2011-09-08', NULL),
    (NULL, 'FSKTX', 'Fidelity Tot Mk', 'FUND', 1, '2011-09-08', NULL),
    (NULL, 'VSTSX', 'Vanguard TSM Idx', 'FUND', 1, '2016-03-29', NULL),
    (NULL, 'FSTPX', 'Fidelity MdCp Id', 'FUND', 1, '2011-09-09', NULL),
    (NULL, 'RWMGX', 'American Funds Wash', 'FUND', 1, '2009-05-01', NULL),
    (NULL, 'FSCKX', 'Fidelity MdCp Id', 'FUND', 1, '2011-09-09', NULL),
    (NULL, 'TILT', 'FlexShs:MS US Mkt Fac', 'FUND', 1, '2011-09-22', NULL),
    (NULL, 'REIPX', 'T Rowe Price Eq Inc', 'FUND', 1, '2015-12-17', NULL),
    (NULL, 'SDOG', 'Alps Sect Div Dogs ETF', 'FUND', 1, '2012-07-16', NULL),
    (NULL, 'SPHD', 'PowerShares S&P500 HD LV', 'FUND', 1, '2012-10-26', NULL),
    (NULL, 'PVSYX', 'Putnam Cap Spectrum', 'FUND', 1, '2009-05-18', NULL),
    (NULL, 'QDF', 'FlexShs:Quality Div', 'FUND', 1, '2012-12-19', NULL),
    (NULL, 'PVSAX', 'Putnam Cap Spectrum', 'FUND', 1, '2009-05-18', NULL),
    (NULL, 'PEQSX', 'Putnam Equity Income', 'FUND', 1, '2012-07-02', NULL),
    (NULL, 'SCHD', 'Schwab Str:US Div Eq ETF', 'FUND', 1, '2011-10-20', NULL),
    (NULL, 'PVSCX', 'Putnam Cap Spectrum', 'FUND', 1, '2009-05-18', NULL),
    (NULL, 'OIEJX', 'JPMorgan:Equity Inc', 'FUND', 1, '2012-01-31', NULL),
    (NULL, 'PMDPX', 'Principal:Sm-MC DvI', 'FUND', 1, '2011-06-07', NULL),
    (NULL, 'PMDIX', 'Principal:Sm-MC DvI', 'FUND', 1, '2011-06-07', NULL),
    (NULL, 'TRPDX', 'T Rowe Price Ret:I2040', 'FUND', 1, '2015-10-02', NULL),
    (NULL, 'FRLLX', 'Fidelity Srs Eqty-Inc', 'FUND', 1, '2012-12-11', NULL),
    (NULL, 'FLMLX', 'Fidelity Adv Srs Eqty-In', 'FUND', 1, '2012-12-10', NULL),
    (NULL, 'ABCYX', 'Am Beacon:LCo Inc Eq', 'FUND', 1, '2012-05-29', NULL),
    (NULL, 'TRPJX', 'T Rowe Price Ret:I2035', 'FUND', 1, '2015-10-02', NULL),
    (NULL, 'FNKLX', 'Fidelity Srs Eqty-Inc', 'FUND', 1, '2012-12-11', NULL),
    (NULL, 'DVIPX', 'Davenport Value & Income', 'FUND', 1, '2010-12-31', NULL),
    (NULL, 'MQIFX', 'Franklin Mut Quest', 'FUND', 1, '1980-09-16', NULL),
    (NULL, 'OIERX', 'JPMorgan:Equity Inc', 'FUND', 1, '2001-02-15', NULL),
    (NULL, 'HDV', 'iShares:Core High Div', 'FUND', 1, '2011-03-31', NULL),
    (NULL, 'RLBGX', 'American Funds Bal', 'FUND', 1, '2009-05-01', NULL),
    (NULL, 'TRPCX', 'T Rowe Price Ret:I2030', 'FUND', 1, '2015-10-02', NULL),
    (NULL, 'RFITX', 'American Funds T2050', 'FUND', 1, '2009-05-01', NULL),
    (NULL, 'OSCIX', 'Oppenheimer Intl SMC', 'FUND', 1, '2011-12-29', NULL),
    (NULL, 'FERGX', 'Fidelity SAI EM Index', 'FUND', 1, '2016-01-05', NULL),
    (NULL, 'FGLLX', 'Fidelity Srs Intr Opp', 'FUND', 1, '2012-12-07', NULL),
    (NULL, 'FDMLX', 'Fidelity Srs Intr Opp', 'FUND', 1, '2012-12-07', NULL),
    (NULL, 'RLLGX', 'American Funds SMCP', 'FUND', 1, '2009-05-01', NULL),
    (NULL, 'HFEIX', 'Henderson:Euro Foc', 'FUND', 1, '2009-03-31', NULL),
    (NULL, 'FKSCX', 'Franklin Intl SCG', 'FUND', 1, '2002-10-21', NULL),
    (NULL, 'PEFIX', 'PIMCO:RAE Fdmtl+EMG', 'FUND', 1, '2008-11-28', NULL),
    (NULL, 'FISMX', 'Fidelity Intl Sm Cap', 'FUND', 1, '2002-09-19', NULL),
    (NULL, 'GPIIX', 'Grandeur Itl Opp', 'FUND', 1, '2011-10-17', NULL),
    (NULL, 'EMRGX', 'Emerging Markets Growth', 'FUND', 1, '2014-11-03', NULL),
    (NULL, 'ARTKX', 'Artisan:Intl Val', 'FUND', 1, '2002-09-24', NULL),
    (NULL, 'RNPGX', 'American Funds NPer', 'FUND', 1, '2009-05-01', NULL),
    (NULL, 'FMGEX', 'Frontier MFG Gl Eq', 'FUND', 1, '2011-12-28', NULL),
    (NULL, 'APHGX', 'Artisan:Glbl Val', 'FUND', 1, '2012-07-17', NULL),
    (NULL, 'OSMAX', 'Oppenheimer Intl SMC', 'FUND', 1, '1997-11-17', NULL),
    (NULL, 'ANWPX', 'American Funds NPer', 'FUND', 1, '1980-01-02', NULL),
    (NULL, 'TEPLX', 'Templeton Growth', 'FUND', 1, '1986-01-02', NULL),
    (NULL, 'DBJP', 'Deutsche MSCI Jp Hdg Eq', 'FUND', 1, '2011-06-09', NULL),
    (NULL, 'MDISX', 'Franklin Mut Gl Disc', 'FUND', 1, '1992-12-31', NULL),
    (NULL, 'ODMAX', 'Oppenheimer Dev Mkts', 'FUND', 1, '1996-11-18', NULL),
    (NULL, 'NMMEX', 'Northern Fds:Act M EM Eq', 'FUND', 1, '2008-12-15', NULL),
    (NULL, 'OPGIX', 'Oppenheimer Glbl Opp', 'FUND', 1, '1990-10-22', NULL),
    (NULL, 'TEMWX', 'Templeton World', 'FUND', 1, '1995-08-14', NULL),
    (NULL, 'BISMX', 'Brandes Inv:Itl SC Eq', 'FUND', 1, '2012-02-03', NULL),
    (NULL, 'XIV', 'VelShs DlyInv VIX ST ETN', 'FUND', 1, '2010-11-30', NULL),
    (NULL, 'SPXL', 'Direxion:S&P 500 Bull 3X', 'FUND', 1, '2008-11-05', NULL),
    (NULL, 'TRNEX', 'T Rowe Price New Era', 'FUND', 1, '2015-12-17', NULL),
    (NULL, 'BBH', 'VnEck Vctrs:Biotech ETF', 'FUND', 1, '1999-11-23', NULL),
    (NULL, 'TNA', 'Direxion:Sm Cap Bull 3X', 'FUND', 1, '2008-11-19', NULL),
    (NULL, 'SMH', 'VnEck Vctrs:Semicnd ETF', 'FUND', 1, '2000-06-05', NULL),
    (NULL, 'KBWB', 'PowerShares KBW Bank', 'FUND', 1, '2011-11-01', NULL),
    (NULL, 'MBXIX', 'Catalyst/Millburn HS', 'FUND', 1, '2015-12-28', NULL),
    (NULL, 'PSCT', 'PowerShares S&P SC Info', 'FUND', 1, '2010-04-07', NULL),
    (NULL, 'VGHCX', 'Vanguard Health Care', 'FUND', 1, '1984-05-23', NULL),
    (NULL, 'QLEIX', 'AQR:Lng-Sht Eqty', 'FUND', 1, '2013-07-16', NULL),
    (NULL, 'FSPHX', 'Fidelity Sel Health', 'FUND', 1, '1981-07-14', NULL),
    (NULL, 'FSCSX', 'Fidelity Sel SW & IT Svc', 'FUND', 1, '1998-12-01', NULL),
    (NULL, 'PHSZX', 'Pru Jenn Health Sci', 'FUND', 1, '1999-06-30', NULL),
    (NULL, 'FBGX', 'UBS AG Enh LC Growth ETN', 'FUND', 1, '2014-06-11', NULL),
    (NULL, 'PHLAX', 'Pru Jenn Health Sci', 'FUND', 1, '1999-06-30', NULL),
    (NULL, 'SHSAX', 'BlackRock:HS Opp', 'FUND', 1, '1999-12-20', NULL),
    (NULL, 'BREIX', 'Baron Real Estate', 'FUND', 1, '2009-12-31', NULL),
    (NULL, 'CGMRX', 'CGM Tr:Realty Fund', 'FUND', 1, '1994-05-13', NULL),
    (NULL, 'PRHSX', 'T Rowe Price Hlth Sci', 'FUND', 1, '1995-12-29', NULL),
    (NULL, 'PRMTX', 'T Rowe Price Md/Tele', 'FUND', 1, '1993-10-13', NULL),
    (NULL, 'FSCHX', 'Fidelity Sel Chemicals', 'FUND', 1, '1985-07-29', NULL),
    (NULL, 'PJP', 'PowerShares Dyn Pharm', 'FUND', 1, '2005-06-23', NULL),
    (NULL, 'FSRPX', 'Fidelity Sel Retailing', 'FUND', 1, '1985-12-16', NULL),
    (NULL, 'FSMEX', 'Fidelity Sel Med Equip', 'FUND', 1, '1998-04-28', NULL),
    (NULL, 'MMIZX', 'MassMutual Sel:S&P500', 'FUND', 1, '2011-12-07', NULL),
    (NULL, 'PRUIX', 'T Rowe Price Eq Idx500', 'FUND', 1, '2015-08-28', NULL),
    (NULL, 'BSPIX', 'BlackRock:S&P500 Idx', 'FUND', 1, '2013-04-11', NULL),
    (NULL, 'FXAIX', 'Fidelity 500 Idx', 'FUND', 1, '2011-05-04', NULL),
    (NULL, 'FXSIX', 'Fidelity 500 Idx', 'FUND', 1, '2011-05-04', NULL),
    (NULL, 'VFFSX', 'Vanguard 500 Index', 'FUND', 1, '2016-03-29', NULL),
    (NULL, 'BSPAX', 'BlackRock:S&P500 Idx', 'FUND', 1, '2013-04-11', NULL),
    (NULL, 'VFINX', 'Vanguard 500 Index', 'FUND', 1, '1980-01-02', NULL),
    (NULL, 'WFIOX', 'WellsFargo:Index', 'FUND', 1, '1986-08-15', NULL),
    (NULL, 'FUSEX', 'Fidelity 500 Idx', 'FUND', 1, '1988-02-17', NULL),
    (NULL, 'SPINX', 'SEI Inst Inv:S&P500', 'FUND', 1, '2013-12-19', NULL),
    (NULL, 'MSPIX', 'MainStay:S&P 500 Idx', 'FUND', 1, '1990-12-31', NULL),
    (NULL, 'VINIX', 'Vanguard Instl Indx', 'FUND', 1, '1990-07-31', NULL),
    (NULL, 'PREIX', 'T Rowe Price Eq Idx500', 'FUND', 1, '1990-03-30', NULL),
    (NULL, 'TISPX', 'TIAA-CREF:S&P500 Idx', 'FUND', 1, '2002-09-30', NULL),
    (NULL, 'HLEIX', 'JPMorgan:Equity Idx', 'FUND', 1, '1991-07-02', NULL),
    (NULL, 'SSEYX', 'SS Inst Inv:Eq 500 Id II', 'FUND', 1, '2014-08-14', NULL),
    (NULL, 'WFSPX', 'BlackRock:S&P500 Idx', 'FUND', 1, '1993-07-02', NULL),
    (NULL, 'SVSPX', 'SSgA:S&P 500 Index', 'FUND', 1, '1992-12-30', NULL),
    (NULL, 'DSPIX', 'Dreyfus Instl S&P 500', 'FUND', 1, '1993-09-30', NULL),
    (NULL, 'NINDX', 'Columbia:LgCp Index', 'FUND', 1, '1993-12-15', NULL),
    (NULL, 'TRSPX', 'TIAA-CREF:S&P500 Idx', 'FUND', 1, '2002-09-06', NULL),
    (NULL, 'PEOPX', 'Dreyfus S&P 500 Index', 'FUND', 1, '1989-12-29', NULL),
    (NULL, 'OGEAX', 'JPMorgan:Equity Idx', 'FUND', 1, '1992-02-18', NULL),
    (NULL, 'GMCDX', 'GMO:Emer Ctry Dbt', 'FUND', 1, '1994-04-19', NULL),
    (NULL, 'HWHIX', 'Hotchkis:High Yield', 'FUND', 1, '2009-03-31', NULL),
    (NULL, 'GMDFX', 'GMO:Emer Ctry Dbt', 'FUND', 1, '1998-01-09', NULL),
    (NULL, 'FMKIX', 'Fidelity Adv Emerg', 'FUND', 1, '1994-03-31', NULL),
    (NULL, 'PTCIX', 'PIMCO:Lng-Tm Credit', 'FUND', 1, '2009-03-31', NULL),
    (NULL, 'FNMIX', 'Fidelity New Mkts Inc', 'FUND', 1, '1993-05-04', NULL),
    (NULL, 'PREMX', 'T Rowe Price Int:EM Bd', 'FUND', 1, '1994-12-30', NULL),
    (NULL, 'AGDAX', 'AB High Income', 'FUND', 1, '1994-02-25', NULL),
    (NULL, 'RITGX', 'American Funds HI', 'FUND', 1, '2009-05-01', NULL),
    (NULL, 'HWHAX', 'Hotchkis:High Yield', 'FUND', 1, '2009-05-29', NULL),
    (NULL, 'MEDIX', 'MFS Emerg Mkt Debt', 'FUND', 1, '1998-03-17', NULL),
    (NULL, 'FAGIX', 'Fidelity Capital & Inc', 'FUND', 1, '1980-01-02', NULL),
    (NULL, 'MEDAX', 'MFS Emerg Mkt Debt', 'FUND', 1, '1998-03-17', NULL),
    (NULL, 'FXICX', 'PIMCO:FISH Series C', 'FUND', 1, '2000-10-18', NULL),
    (NULL, 'NHILX', 'Neuberger Hi Inc B', 'FUND', 1, '2009-05-27', NULL),
    (NULL, 'AGDCX', 'AB High Income', 'FUND', 1, '1994-02-25', NULL),
    (NULL, 'PEBIX', 'PIMCO:Em Mkts Bd', 'FUND', 1, '1997-07-31', NULL),
    (NULL, 'PONPX', 'PIMCO:Income', 'FUND', 1, '2008-04-30', NULL),
    (NULL, 'TGEIX', 'TCW:Em Mkts Income', 'FUND', 1, '1998-05-29', NULL),
    (NULL, 'EIHIX', 'Eaton Vance HI Opp', 'FUND', 1, '2009-12-09', NULL),
    (NULL, 'LSBDX', 'Loomis Sayles:Bond', 'FUND', 1, '1991-05-10', NULL),
    (NULL, 'FIHBX', 'Federated HY Bond', 'FUND', 1, '2002-11-04', NULL),
    (NULL, 'PIMIX', 'PIMCO:Income', 'FUND', 1, '2007-04-02', NULL),
    (NULL, 'LSFIX', 'Loomis Sayles:Fx In', 'FUND', 1, '1995-01-17', NULL),
    (NULL, 'GSDIX', 'Goldman:Emg Mkts Dbt', 'FUND', 1, '2003-09-02', NULL),
    (NULL, 'DVHIX', 'Delaware Natl HY', 'FUND', 1, '2008-12-31', NULL),
    (NULL, 'PGOVX', 'PIMCO:Lng-Tm Govt', 'FUND', 1, '1991-06-28', NULL),
    (NULL, 'MOTMX', 'BNY Mellon:Mun Opp', 'FUND', 1, '2008-10-16', NULL),
    (NULL, 'HYD', 'VnEck Vctrs:HY Muni Indx', 'FUND', 1, '2009-02-05', NULL),
    (NULL, 'MMHIX', 'MainStay:Hi Yld Muni', 'FUND', 1, '2010-03-30', NULL),
    (NULL, 'SHMMX', 'WA Managed Muni', 'FUND', 1, '1981-03-04', NULL),
    (NULL, 'VUSTX', 'Vanguard Lg-Tm Trs', 'FUND', 1, '1986-05-19', NULL),
    (NULL, 'MMHAX', 'MainStay:Hi Yld Muni', 'FUND', 1, '2010-03-30', NULL),
    (NULL, 'ELFTX', 'Elfun Tax-Ex Income Fund', 'FUND', 1, '1980-01-02', NULL),
    (NULL, 'WFCMX', 'WellsFargo:CreBldr Srs M', 'FUND', 1, '2008-04-16', NULL),
    (NULL, 'ORNYX', 'Oppenheimer Ro HY M', 'FUND', 1, '2010-11-29', NULL),
    (NULL, 'USTEX', 'USAA Tax Ex Lng-Tm', 'FUND', 1, '1982-03-19', NULL),
    (NULL, 'FGOVX', 'Fidelity Inc:Govt Inc', 'FUND', 1, '1980-01-02', NULL),
    (NULL, 'MANLX', 'BlackRock:Nat Muni', 'FUND', 1, '1980-01-02', NULL),
    (NULL, 'COLTX', 'Columbia:Tax-Exempt', 'FUND', 1, '1980-01-02', NULL),
    (NULL, 'ABTYX', 'AB Hi Inc Muni', 'FUND', 1, '2010-02-08', NULL),
    (NULL, 'PRFHX', 'T Rowe Price Tx-Fr HY', 'FUND', 1, '1985-02-28', NULL),
    (NULL, 'MISHX', 'AB Municipal Inc', 'FUND', 1, '2012-10-01', NULL),
    (NULL, 'SRHMX', 'Columbia:Hi Yld Muni', 'FUND', 1, '1995-11-03', NULL),
    (NULL, 'CPTNX', 'Amer Cent:Govt Bond', 'FUND', 1, '1980-05-16', NULL),
    (NULL, 'FTFMX', 'Fidelity NY Muni Inc', 'FUND', 1, '1984-07-10', NULL),
    (NULL, 'VWAHX', 'Vanguard Hi Yld TxEx', 'FUND', 1, '1980-01-02', NULL),
    (NULL, 'USATX', 'USAA Tax Ex Intm-Tm', 'FUND', 1, '1982-03-19', NULL),
    (NULL, 'FKTIX', 'Franklin Fed TF Inc', 'FUND', 1, '1983-10-07', NULL),
    (NULL, 'OPNYX', 'Oppenheimer Ro NY M', 'FUND', 1, '1984-08-16', NULL);