package petstore;

import com.intuit.karate.junit5.Karate;

public class PetstoreRunner {
    @Karate.Test
    Karate testAll() {
        return Karate.run().relativeTo(getClass());
    }
}
