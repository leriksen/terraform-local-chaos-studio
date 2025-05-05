run "test_chaos_studio" {
  command = plan

  module {
    source = "../"
  }

  variables {
    location = "doesnt-matter"
    service_targets = {
      "doesntmatter" = {
        target_id   = "doesnt/matter"
        target_type = "Microsoft-WrongType"
      }
    }
  }

  expect_failures = [
    var.service_targets["doesntmatter"].target_type
  ]
}