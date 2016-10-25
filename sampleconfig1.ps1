Configuration SampleConfig1 {

    Import-DscResource -Module nx

    Node  "localhost" {
        nxFile ExampleFile {

            DestinationPath = "/tmp/example"
            Contents = "Hello world! `n"
            Ensure = "Present"
            Type = "File"
        }

    }
}