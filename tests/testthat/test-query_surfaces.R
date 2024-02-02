
test_that("query_surfaces() returns proper list of info", {
  skip_if_offline()
  vcr::use_cassette("query_surfaces_all", {
    surface_query <- query_surfaces()

    expect_type(surface_query, "list")
    expect_length(surface_query, 17)
    expect_named(
      surface_query,
      c(
        "vegtype_1",
        "vegtype_2",
        "vegtype_3",
        "vegtype_4",
        "vegtype_5",
        "vegtype_6",
        "vegtype_7",
        "vegtype_8",
        "vegtype_9",
        "vegtype_10",
        "vegtype_11",
        "vegtype_12",
        "vegtype_20",
        "seaice",
        "openwater",
        "airportice",
        "airportgrass"
      )
    )
  })
})

test_that("query_surfaces() returns list of surface information", {
  skip_if_offline()
  vcr::use_cassette("query_surfaces_seaice", {
    surface_query <- query_surfaces(surface_alias = "seaice")
    expect_type(surface_query, "list")
    expect_length(surface_query, 4)
    expect_named(surface_query,
                 c("Long_Name", "IGBP_Type", "Veg_Type", "Roughness"))
  })
})
