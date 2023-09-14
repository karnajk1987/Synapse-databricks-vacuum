--To create schema and table use the below query

CREATE TABLE [monitoring].[Housekeeping_Vacuum](
    [HID] [int] IDENTITY(1,1) NOT NULL,
    [TargetFolderPath] [nvarchar](max) NULL,
    [LastVaccumDateTime] [datetime] NULL,
    [LastZOrderDateTime] [datetime] NULL,
    [Comments] [varchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
    [HID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

--To create schema if it does not exists
CREATE SCHEMA monitoring


--If the data is available then use the below to check it
select * from [monitoring].[Housekeeping_Vacuum]