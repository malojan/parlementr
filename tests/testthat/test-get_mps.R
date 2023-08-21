
test_that("get_mps() get member of parliaments", {
  expect_equal(get_mps("15", "all")[[1, 2]] == "Cédric Roussel", TRUE)
})
