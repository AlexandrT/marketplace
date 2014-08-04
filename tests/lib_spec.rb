require '../lib'

describe "test functions" do
  it "clean_trash" do
    # clean_trash("1\t").to eq("1 ")
    expect(clean_trash("1\t")).to eq("1")
    expect(clean_trash("1\r")).to eq("1")
    expect(clean_trash("1\n")).to eq("1")
    expect(clean_trash("1<br>")).to eq("1")
    expect(clean_trash("1  ")).to eq("1")
    expect(clean_trash("1  1")).to eq("1 1")
    expect(clean_trash("1   1")).to eq("1 1")
    expect(clean_trash("1    1")).to eq("1 1")
    expect(clean_trash("    1")).to eq("1")
    expect(clean_trash("1   \n 1")).to eq("1 1")
    expect(clean_trash("1   \n ")).to eq("1")
  end
end