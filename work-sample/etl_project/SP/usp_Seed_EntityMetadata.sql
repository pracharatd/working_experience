IF OBJECT_ID('JobConfig.usp_Seed_EntityMetadata') IS NOT NULL
    DROP PROCEDURE JobConfig.usp_Seed_EntityMetadata;
GO

CREATE PROCEDURE JobConfig.usp_Seed_EntityMetadata
AS
BEGIN

    DECLARE @Now DATETIME2 = SYSDATETIME();

    INSERT INTO JobConfig.EntityMetadata
    (
        EntityName,
        SourceType,
        RawContainer,
        RawFolder,
        RawFileName,
        LandingContainer,
        LandingFolder,
        BronzeSchema,
        BronzeTable,
        BronzeProcedure,
        SilverSchema,
        SilverProcedure,
        GoldSchema,
        GoldProcedure,
        LoadType,
        ExecutionOrder,
        RequiresCustomMapping,
        IsActive,
        CreatedAt
    )
    VALUES
    ('currencyexchange','CSV',
     'synapsecontainer','source','currencyexchange.csv',
     'synapsecontainer','landing/currencyexchange',
     'bronze','currencyexchange','bronze.bulk_load_generic',
     'silver',NULL,
     'gold',NULL,
     'FULL',1,0,1,@Now);

    INSERT INTO JobConfig.EntityMetadata
    (
        EntityName, SourceType,
        RawContainer, RawFolder, RawFileName,
        LandingContainer, LandingFolder,
        BronzeSchema, BronzeTable, BronzeProcedure,
        SilverSchema, SilverProcedure,
        GoldSchema, GoldProcedure,
        LoadType, ExecutionOrder, RequiresCustomMapping, IsActive, CreatedAt
    )
    VALUES
    ('customer','CSV',
     'synapsecontainer','source','customer.csv',
     'synapsecontainer','landing/customer',
     'bronze','customer','bronze.bulk_load_generic',
     'silver','silver.sp_Load_Customer',
     'gold','gold.sp_Load_dim_customer',
     'FULL',2,0,1,@Now);

    INSERT INTO JobConfig.EntityMetadata
    (
        EntityName, SourceType,
        RawContainer, RawFolder, RawFileName,
        LandingContainer, LandingFolder,
        BronzeSchema, BronzeTable, BronzeProcedure,
        SilverSchema, SilverProcedure,
        GoldSchema, GoldProcedure,
        LoadType, ExecutionOrder, RequiresCustomMapping, IsActive, CreatedAt
    )
    VALUES
    ('orders','CSV',
     'synapsecontainer','source','orders.csv',
     'synapsecontainer','landing/orders',
     'bronze','orders','bronze.bulk_load_generic',
     'silver','silver.sp_Load_Orders',
     'gold','gold.sp_Load_fact_orders',
     'FULL',6,0,1,@Now);

    INSERT INTO JobConfig.EntityMetadata
    (
        EntityName, SourceType,
        RawContainer, RawFolder, RawFileName,
        LandingContainer, LandingFolder,
        BronzeSchema, BronzeTable, BronzeProcedure,
        SilverSchema, SilverProcedure,
        GoldSchema, GoldProcedure,
        LoadType, ExecutionOrder, RequiresCustomMapping, IsActive, CreatedAt
    )
    VALUES
    ('orderrows','CSV',
     'synapsecontainer','source','orderrows.csv',
     'synapsecontainer','landing/orderrows',
     'bronze','orderrows','bronze.bulk_load_generic',
     'silver',NULL,
     'gold',NULL,
     'FULL',5,0,1,@Now);

    INSERT INTO JobConfig.EntityMetadata
    (
        EntityName, SourceType,
        RawContainer, RawFolder, RawFileName,
        LandingContainer, LandingFolder,
        BronzeSchema, BronzeTable, BronzeProcedure,
        SilverSchema, SilverProcedure,
        GoldSchema, GoldProcedure,
        LoadType, ExecutionOrder, RequiresCustomMapping, IsActive, CreatedAt
    )
    VALUES
    ('sales','CSV',
     'synapsecontainer','source','sales.csv',
     'synapsecontainer','landing/sales',
     'bronze','sales','bronze.bulk_load_generic',
     'silver','silver.sp_Load_Sales',
     'gold','gold.sp_Load_fact_sales',
     'FULL',7,0,1,@Now);

    INSERT INTO JobConfig.EntityMetadata
    (
        EntityName, SourceType,
        RawContainer, RawFolder, RawFileName,
        LandingContainer, LandingFolder,
        BronzeSchema, BronzeTable, BronzeProcedure,
        SilverSchema, SilverProcedure,
        GoldSchema, GoldProcedure,
        LoadType, ExecutionOrder, RequiresCustomMapping, IsActive, CreatedAt
    )
    VALUES
    ('product','JSON',
     'synapsecontainer','source','product.json',
     'synapsecontainer','landing/product',
     'bronze','product','bronze.bulk_load_generic',
     'silver','silver.sp_Load_Product',
     'gold','gold.sp_Load_dim_product',
     'FULL',3,1,1,@Now);

    INSERT INTO JobConfig.EntityMetadata
    (
        EntityName, SourceType,
        RawContainer, RawFolder, RawFileName,
        LandingContainer, LandingFolder,
        BronzeSchema, BronzeTable, BronzeProcedure,
        SilverSchema, SilverProcedure,
        GoldSchema, GoldProcedure,
        LoadType, ExecutionOrder, RequiresCustomMapping, IsActive, CreatedAt
    )
    VALUES
    ('store','JSON',
     'synapsecontainer','source','store.json',
     'synapsecontainer','landing/store',
     'bronze','store','bronze.bulk_load_generic',
     'silver','silver.sp_Load_Store',
     'gold','gold.sp_Load_dim_store',
     'FULL',4,1,1,@Now);

END
GO
