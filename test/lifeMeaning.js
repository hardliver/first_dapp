const LifeMeaning = artifacts.require("LifeMeaning");
contract("LifeMeaning", () => {
  it("Should read the same value that was set", async () => {
    const lifeMeaning = await LifeMeaning.deployed();
    await lifeMeaning.set(42);
    const result = await lifeMeaning.get();
    assert(result.toNumber() == 42);
  })
})
