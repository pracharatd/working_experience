/* =========================================================
   1. CREATE SCHEMAS
========================================================= */

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'bronze')
    EXEC('CREATE SCHEMA bronze');
GO

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'silver')
    EXEC('CREATE SCHEMA silver');
GO

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'gold')
    EXEC('CREATE SCHEMA gold');
GO

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'JobConfig')
    EXEC('CREATE SCHEMA JobConfig');
GO


/* =========================================================
   2. JOBCONFIG TABLES
========================================================= */

-- Batch-level tracking
IF OBJECT_ID('JobConfig.BatchTime') IS NOT NULL
    DROP TABLE JobConfig.BatchTime;
GO

CREATE TABLE JobConfig.BatchTime
(
    BatchId         INT IDENTITY(1,1) NOT NULL,
    BatchName       VARCHAR(200) NOT NULL,

    BatchStartTime  DATETIME2 NOT NULL,
    BatchEndTime    DATETIME2 NULL,

    Status          VARCHAR(20) NOT NULL,
    DurationSeconds INT NULL,

    CreatedAt       DATETIME2 NOT NULL,
    UpdatedAt       DATETIME2 NULL
)
WITH
(
    DISTRIBUTION = ROUND_ROBIN,
    HEAP
);
GO

-- Job execution history (per step inside batch)
IF OBJECT_ID('JobConfig.JobRunHistory') IS NOT NULL
    DROP TABLE JobConfig.JobRunHistory;
GO

CREATE TABLE JobConfig.JobRunHistory
(
    JobRunId            INT IDENTITY(1,1) NOT NULL,
    BatchId             INT NOT NULL,
    EntityId            INT NOT NULL,

    Zone                VARCHAR(100) NOT NULL,
    EntityName          VARCHAR(150) NOT NULL,
    PipelineName        VARCHAR(150) NULL,
    StoredProcedureName VARCHAR(150) NULL,

    JobStartTime        DATETIME2 NOT NULL,
    JobEndTime          DATETIME2 NULL,

    Status              VARCHAR(20) NOT NULL,
    RowsProcessed       BIGINT NULL,
    DurationSeconds     INT NULL,

    ErrorMessage        VARCHAR(4000) NULL,
    Comments            VARCHAR(2000) NULL,

    CreatedAt           DATETIME2 NOT NULL,
    UpdatedAt           DATETIME2 NULL
)
WITH
(
    DISTRIBUTION = ROUND_ROBIN,
    HEAP
);
GO

--Metadata Driven Table
IF OBJECT_ID('JobConfig.EntityMetadata') IS NOT NULL
    DROP TABLE JobConfig.EntityMetadata;
GO

CREATE TABLE JobConfig.EntityMetadata
(
    EntityId            INT IDENTITY(1,1) NOT NULL,

    -- Basic info
    EntityName          VARCHAR(150) NOT NULL,
    SourceType          VARCHAR(20) NOT NULL,       -- CSV / JSON

    -- RAW
    RawContainer        VARCHAR(100) NOT NULL,
    RawFolder           VARCHAR(200) NOT NULL,
    RawFileName         VARCHAR(200) NOT NULL,

    -- LANDING
    LandingContainer    VARCHAR(100) NOT NULL,
    LandingFolder       VARCHAR(200) NOT NULL,

    -- BRONZE
    BronzeSchema        VARCHAR(50) NOT NULL,
    BronzeTable         VARCHAR(150) NOT NULL,
    BronzeProcedure     VARCHAR(200) NULL,

    -- SILVER (for later)
    SilverSchema        VARCHAR(50) NULL,
    SilverProcedure     VARCHAR(200) NULL,

    -- GOLD (for later)
    GoldSchema          VARCHAR(50) NULL,
    GoldProcedure       VARCHAR(200) NULL,

    LoadType            VARCHAR(10) NOT NULL,       -- FULL / DELTA
    ExecutionOrder      INT NOT NULL,
    RequiresCustomMapping BIT NOT NULL,
    IsActive            BIT NOT NULL,

    CreatedAt           DATETIME2 NOT NULL,
    UpdatedAt           DATETIME2 NULL
)
WITH
(
    DISTRIBUTION = ROUND_ROBIN,
    HEAP
);
GO

/* =========================================================
   3. BRONZE TABLES
========================================================= */
IF NOT EXISTS (SELECT * FROM sys.objects O JOIN sys.schemas S ON O.schema_id = S.schema_id WHERE O.NAME = 'currencyexchange' AND O.TYPE = 'U' AND S.NAME = 'bronze')
CREATE TABLE bronze.currencyexchange
	(
	 [Date] nvarchar(4000),
	 [FromCurrency] nvarchar(4000),
	 [ToCurrency] nvarchar(4000),
	 [Exchange] nvarchar(4000)
	)
WITH
	(
	DISTRIBUTION = ROUND_ROBIN,
	 CLUSTERED COLUMNSTORE INDEX
	 -- HEAP
	)
GO

IF NOT EXISTS (SELECT * FROM sys.objects O JOIN sys.schemas S ON O.schema_id = S.schema_id WHERE O.NAME = 'customer' AND O.TYPE = 'U' AND S.NAME = 'bronze')
CREATE TABLE bronze.customer
	(
	 [CustomerKey] nvarchar(4000),
	 [GeoAreaKey] nvarchar(4000),
	 [StartDT] nvarchar(4000),
	 [EndDT] nvarchar(4000),
	 [Continent] nvarchar(4000),
	 [Gender] nvarchar(4000),
	 [Title] nvarchar(4000),
	 [GivenName] nvarchar(4000),
	 [MiddleInitial] nvarchar(4000),
	 [Surname] nvarchar(4000),
	 [StreetAddress] nvarchar(4000),
	 [City] nvarchar(4000),
	 [State] nvarchar(4000),
	 [StateFull] nvarchar(4000),
	 [ZipCode] nvarchar(4000),
	 [Country] nvarchar(4000),
	 [CountryFull] nvarchar(4000),
	 [Birthday] nvarchar(4000),
	 [Age] nvarchar(4000),
	 [Occupation] nvarchar(4000),
	 [Company] nvarchar(4000),
	 [Vehicle] nvarchar(4000),
	 [Latitude] nvarchar(4000),
	 [Longitude] nvarchar(4000)
	)
WITH
	(
	DISTRIBUTION = ROUND_ROBIN,
	 CLUSTERED COLUMNSTORE INDEX
	 -- HEAP
	)
GO

IF NOT EXISTS (SELECT * FROM sys.objects O JOIN sys.schemas S ON O.schema_id = S.schema_id WHERE O.NAME = 'orderrows' AND O.TYPE = 'U' AND S.NAME = 'bronze')
CREATE TABLE bronze.orderrows
	(
	 [OrderKey] nvarchar(4000),
	 [LineNumber] nvarchar(4000),
	 [ProductKey] nvarchar(4000),
	 [Quantity] nvarchar(4000),
	 [UnitPrice] nvarchar(4000),
	 [NetPrice] nvarchar(4000),
	 [UnitCost] nvarchar(4000)
	)
WITH
	(
	DISTRIBUTION = ROUND_ROBIN,
	 CLUSTERED COLUMNSTORE INDEX
	 -- HEAP
	)
GO

IF NOT EXISTS (SELECT * FROM sys.objects O JOIN sys.schemas S ON O.schema_id = S.schema_id WHERE O.NAME = 'orders' AND O.TYPE = 'U' AND S.NAME = 'bronze')
CREATE TABLE bronze.orders
	(
	 [OrderKey] nvarchar(4000),
	 [CustomerKey] nvarchar(4000),
	 [StoreKey] nvarchar(4000),
	 [OrderDate] nvarchar(4000),
	 [DeliveryDate] nvarchar(4000),
	 [CurrencyCode] nvarchar(4000)
	)
WITH
	(
	DISTRIBUTION = ROUND_ROBIN,
	 CLUSTERED COLUMNSTORE INDEX
	 -- HEAP
	)
GO

IF NOT EXISTS (SELECT * FROM sys.objects O JOIN sys.schemas S ON O.schema_id = S.schema_id WHERE O.NAME = 'product' AND O.TYPE = 'U' AND S.NAME = 'bronze')
CREATE TABLE bronze.product
	(
	 [ProductKey] bigint,
	 [ProductCode] nvarchar(4000),
	 [ProductName] nvarchar(4000),
	 [Manufacturer] nvarchar(4000),
	 [Brand] nvarchar(4000),
	 [Color] nvarchar(4000),
	 [WeightUnit] nvarchar(4000),
	 [Weight] nvarchar(4000),
	 [Cost] float,
	 [Price] float,
	 [CategoryKey] bigint,
	 [CategoryName] nvarchar(4000),
	 [SubCategoryKey] bigint,
	 [SubCategoryName] nvarchar(4000)
	)
WITH
	(
	DISTRIBUTION = ROUND_ROBIN,
	 CLUSTERED COLUMNSTORE INDEX
	 -- HEAP
	)
GO

IF NOT EXISTS (SELECT * FROM sys.objects O JOIN sys.schemas S ON O.schema_id = S.schema_id WHERE O.NAME = 'sales' AND O.TYPE = 'U' AND S.NAME = 'bronze')
CREATE TABLE bronze.sales
	(
	 [OrderKey] nvarchar(4000),
	 [LineNumber] nvarchar(4000),
	 [OrderDate] nvarchar(4000),
	 [DeliveryDate] nvarchar(4000),
	 [CustomerKey] nvarchar(4000),
	 [StoreKey] nvarchar(4000),
	 [ProductKey] nvarchar(4000),
	 [Quantity] nvarchar(4000),
	 [UnitPrice] nvarchar(4000),
	 [NetPrice] nvarchar(4000),
	 [UnitCost] nvarchar(4000),
	 [CurrencyCode] nvarchar(4000),
	 [ExchangeRate] nvarchar(4000)
	)
WITH
	(
	DISTRIBUTION = ROUND_ROBIN,
	 CLUSTERED COLUMNSTORE INDEX
	 -- HEAP
	)
GO

IF NOT EXISTS (SELECT * FROM sys.objects O JOIN sys.schemas S ON O.schema_id = S.schema_id WHERE O.NAME = 'store' AND O.TYPE = 'U' AND S.NAME = 'bronze')
CREATE TABLE bronze.store
	(
	 [StoreKey] bigint,
	 [StoreCode] bigint,
	 [GeoAreaKey] bigint,
	 [CountryCode] nvarchar(4000),
	 [CountryName] nvarchar(4000),
	 [State] nvarchar(4000),
	 [OpenDate] nvarchar(4000),
	 [CloseDate] nvarchar(4000),
	 [Description] nvarchar(4000),
	 [SquareMeters] nvarchar(4000),
	 [Status] nvarchar(4000)
	)
WITH
	(
	DISTRIBUTION = ROUND_ROBIN,
	 CLUSTERED COLUMNSTORE INDEX
	 -- HEAP
	)
GO

/* =========================================================
   4. SILVER TABLES
========================================================= */
IF OBJECT_ID('silver.customer') IS NULL
CREATE TABLE silver.customer
(
    CustomerKey INT NOT NULL,
    GeoAreaKey INT,
    StartDT DATE,
    EndDT DATE,
    Continent VARCHAR(100),
    Gender VARCHAR(20),
    Title VARCHAR(50),
    GivenName VARCHAR(100),
    MiddleInitial VARCHAR(50),
    Surname VARCHAR(100),
    StreetAddress VARCHAR(200),
    City VARCHAR(100),
    State VARCHAR(50),
    StateFull VARCHAR(100),
    ZipCode VARCHAR(20),
    Country VARCHAR(50),
    CountryFull VARCHAR(100),
    Birthday DATE,
    Age INT,
    Occupation VARCHAR(200),
    Company VARCHAR(200),
    Vehicle VARCHAR(200),
    Latitude DECIMAL(18,10),
    Longitude DECIMAL(18,10),
    CONSTRAINT PK_silver_customer 
        PRIMARY KEY NONCLUSTERED (CustomerKey) NOT ENFORCED
)
WITH
(
    DISTRIBUTION = HASH(CustomerKey),
    CLUSTERED COLUMNSTORE INDEX
);
GO

IF OBJECT_ID('silver.product') IS NULL
CREATE TABLE silver.product
(
    ProductKey INT NOT NULL,
    ProductCode VARCHAR(50),
    ProductName VARCHAR(200),
    Manufacturer VARCHAR(200),
    Brand VARCHAR(200),
    Color VARCHAR(50),
    WeightUnit VARCHAR(50),
    Weight DECIMAL(18,4),
    Cost DECIMAL(18,4),
    Price DECIMAL(18,4),
    CategoryKey INT,
    CategoryName VARCHAR(200),
    SubCategoryKey INT,
    SubCategoryName VARCHAR(200),
    CONSTRAINT PK_silver_product 
        PRIMARY KEY NONCLUSTERED (ProductKey) NOT ENFORCED
)
WITH
(
    DISTRIBUTION = HASH(ProductKey),
    CLUSTERED COLUMNSTORE INDEX
);
GO

IF OBJECT_ID('silver.store') IS NULL
CREATE TABLE silver.store
(
    StoreKey INT NOT NULL,
    StoreCode INT,
    GeoAreaKey INT,
    CountryCode VARCHAR(10),
    CountryName VARCHAR(100),
    State VARCHAR(100),
    OpenDate DATE,
    CloseDate DATE NULL,
    Description VARCHAR(255),
    SquareMeters INT,
    Status VARCHAR(50),
    CONSTRAINT PK_silver_store 
        PRIMARY KEY NONCLUSTERED (StoreKey) NOT ENFORCED
)
WITH
(
    DISTRIBUTION = HASH(StoreKey),
    CLUSTERED COLUMNSTORE INDEX
);
GO

IF OBJECT_ID('silver.orders') IS NULL
CREATE TABLE silver.orders
(
    OrderKey INT NOT NULL,
    LineNumber INT NOT NULL,
    CustomerKey INT,
    StoreKey INT,
    ProductKey INT,
    OrderDate DATE,
    DeliveryDate DATE,
    CurrencyCode VARCHAR(200),
    Quantity INT,
    UnitPriceUSD DECIMAL(18,4),
    NetPriceUSD DECIMAL(18,4),
    UnitCostUSD DECIMAL(18,4),
    CONSTRAINT PK_silver_orders 
        PRIMARY KEY NONCLUSTERED (OrderKey, LineNumber) NOT ENFORCED
)
WITH
(
    DISTRIBUTION = HASH(OrderKey),
    CLUSTERED COLUMNSTORE INDEX
);
GO

IF OBJECT_ID('silver.sales') IS NULL
CREATE TABLE silver.sales
(
    OrderKey INT NOT NULL,
    LineNumber INT NOT NULL,
    OrderDate DATE,
    DeliveryDate DATE,
    CustomerKey INT,
    StoreKey INT,
    ProductKey INT,
    Quantity INT,
    UnitPriceUSD DECIMAL(18,4),
    NetPriceUSD DECIMAL(18,4),
    UnitCostUSD DECIMAL(18,4),
    CONSTRAINT PK_silver_sales 
        PRIMARY KEY NONCLUSTERED (OrderKey, LineNumber) NOT ENFORCED
)
WITH
(
    DISTRIBUTION = HASH(OrderKey),
    CLUSTERED COLUMNSTORE INDEX
);
GO

/* =========================================================
   5. GOLD DIMENSIONS (SCD TYPE 2 READY)
========================================================= */

--gold.dim_customer
IF OBJECT_ID('gold.dim_customer') IS NOT NULL
    DROP TABLE gold.dim_customer;
GO

CREATE TABLE gold.dim_customer
(
    CustomerSK INT IDENTITY(1,1) NOT NULL,
    CustomerKey INT NOT NULL,

    GeoAreaKey INT,
    Continent VARCHAR(100),
    Gender VARCHAR(20),
    Title VARCHAR(50),
    GivenName VARCHAR(100),
    MiddleInitial VARCHAR(50),
    Surname VARCHAR(100),
    StreetAddress VARCHAR(200),
    City VARCHAR(100),
    State VARCHAR(50),
    StateFull VARCHAR(100),
    ZipCode VARCHAR(50),
    Country VARCHAR(50),
    CountryFull VARCHAR(100),
    Birthday DATE,
    Age INT,
    Occupation VARCHAR(200),
    Company VARCHAR(200),
    Vehicle VARCHAR(200),
    Latitude DECIMAL(18,10),
    Longitude DECIMAL(18,10),

    EffectiveStartDate DATETIME2 NOT NULL,
    EffectiveEndDate   DATETIME2 NOT NULL,
    IsCurrent          BIT NOT NULL,

    CONSTRAINT PK_dim_customer 
        PRIMARY KEY NONCLUSTERED (CustomerSK) NOT ENFORCED
)
WITH
(
    DISTRIBUTION = REPLICATE,
    HEAP
);
GO

CREATE INDEX IX_dim_customer_BK_Current
ON gold.dim_customer (CustomerKey, IsCurrent);
GO

--gold.dim_product
IF OBJECT_ID('gold.dim_product') IS NOT NULL
    DROP TABLE gold.dim_product;
GO

CREATE TABLE gold.dim_product
(
    ProductSK INT IDENTITY(1,1) NOT NULL,
    ProductKey INT NOT NULL,

    ProductCode VARCHAR(50),
    ProductName VARCHAR(200),
    Manufacturer VARCHAR(200),
    Brand VARCHAR(200),
    Color VARCHAR(50),
    WeightUnit VARCHAR(50),
    Weight DECIMAL(18,4),
    Cost DECIMAL(18,4),
    Price DECIMAL(18,4),
    CategoryKey INT,
    CategoryName VARCHAR(200),
    SubCategoryKey INT,
    SubCategoryName VARCHAR(200),

    EffectiveStartDate DATETIME2 NOT NULL,
    EffectiveEndDate   DATETIME2 NOT NULL,
    IsCurrent          BIT NOT NULL,

    CONSTRAINT PK_dim_product
        PRIMARY KEY NONCLUSTERED (ProductSK) NOT ENFORCED
)
WITH
(
    DISTRIBUTION = REPLICATE,
    HEAP
);
GO

CREATE INDEX IX_dim_product_BK_Current
ON gold.dim_product (ProductKey, IsCurrent);
GO

--gold.dim_store
IF OBJECT_ID('gold.dim_store') IS NOT NULL
    DROP TABLE gold.dim_store;
GO

CREATE TABLE gold.dim_store
(
    StoreSK INT IDENTITY(1,1) NOT NULL,
    StoreKey INT NOT NULL,

    StoreCode INT,
    GeoAreaKey INT,
    CountryCode VARCHAR(50),
    CountryName VARCHAR(100),
    State VARCHAR(100),
    OpenDate DATE,
    CloseDate DATE,
    Description VARCHAR(255),
    SquareMeters INT,
    Status VARCHAR(50),

    EffectiveStartDate DATETIME2 NOT NULL,
    EffectiveEndDate   DATETIME2 NOT NULL,
    IsCurrent          BIT NOT NULL,

    CONSTRAINT PK_dim_store
        PRIMARY KEY NONCLUSTERED (StoreSK) NOT ENFORCED
)
WITH
(
    DISTRIBUTION = REPLICATE,
    HEAP
);
GO

CREATE INDEX IX_dim_store_BK_Current
ON gold.dim_store (StoreKey, IsCurrent);
GO

--gold.fact_orders
IF OBJECT_ID('gold.fact_orders') IS NOT NULL
    DROP TABLE gold.fact_orders;
GO

CREATE TABLE gold.fact_orders
(
    FactOrderSK BIGINT IDENTITY(1,1) NOT NULL,
    OrderKey INT NOT NULL,

    CustomerSK INT NOT NULL,
    StoreSK INT NOT NULL,

    OrderDate DATE NOT NULL,
    DeliveryDate DATE NULL,

    TotalQuantity INT NOT NULL,
    TotalNetAmount  DECIMAL(18,4) NOT NULL,
    TotalCostAmount DECIMAL(18,4) NOT NULL,

    CreatedAt DATETIME2 NOT NULL,
    UpdatedAt DATETIME2 NULL,

    CONSTRAINT PK_fact_orders
        PRIMARY KEY NONCLUSTERED (FactOrderSK) NOT ENFORCED
)
WITH
(
    DISTRIBUTION = HASH(OrderKey),
    CLUSTERED COLUMNSTORE INDEX
);
GO

--gold.fact_sales
IF OBJECT_ID('gold.fact_sales') IS NOT NULL
    DROP TABLE gold.fact_sales;
GO

CREATE TABLE gold.fact_sales
(
    FactSalesSK BIGINT IDENTITY(1,1) NOT NULL,

    OrderKey INT NOT NULL,
    LineNumber INT NOT NULL,

    CustomerSK INT NOT NULL,
    StoreSK INT NOT NULL,
    ProductSK INT NOT NULL,

    OrderDate DATE NOT NULL,
    DeliveryDate DATE NULL,

    Quantity INT NOT NULL,

    UnitPriceUSD DECIMAL(18,4) NOT NULL,
    NetPriceUSD  DECIMAL(18,4) NOT NULL,
    UnitCostUSD  DECIMAL(18,4) NOT NULL,

    CreatedAt DATETIME2 NOT NULL,
    UpdatedAt DATETIME2 NULL,

    CONSTRAINT PK_fact_sales
        PRIMARY KEY NONCLUSTERED (FactSalesSK) NOT ENFORCED
)
WITH
(
    DISTRIBUTION = HASH(OrderKey),
    CLUSTERED COLUMNSTORE INDEX
);
GO