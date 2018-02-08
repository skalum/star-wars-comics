require 'spec_helper'

RSpec.describe StarWarsComics::Series do
  context 'Class Methods' do

    around(:each) do |example|
      VCR.use_cassette("series", :record => :new_episodes) do
        example.run
      end
    end

    let(:series){StarWarsComics::Series.all}

    describe '.all' do
      it 'returns an array of series' do
        expect(series).to be_an(Array)
        expect(series.first).to be_a(StarWarsComics::Series)
      end

      it 'correctly scrapes names and urls for the series' do
        expect(series.first.name).to eq("Star Wars Adventures: Forces of Destiny")
        expect(series.first.path).to eq("/wiki/Star_Wars_Adventures:_Forces_of_Destiny")
      end
    end

    describe '.find' do
      it 'returns the series based on position in @@all' do
        expect(StarWarsComics::Series.find(1)).to eq(series[0])
      end
    end

    describe '.find_by_name' do
      it 'returns the series based on the name' do
        expect(StarWarsComics::Series.find_by_name("Star Wars Adventures: Forces of Destiny")).to eq(series[0])
      end
    end
  end

  context 'Instance Methods' do
    let(:subject){StarWarsComics::Series.new("Star Wars Adventures: Forces of Destiny", "/wiki/Star_Wars_Adventures:_Forces_of_Destiny")}

    describe '#name' do
      it 'has a name' do
        expect(subject.name).to eq("Star Wars Adventures: Forces of Destiny")
      end
    end

    describe '#path' do
      it 'has a path' do
        expect(subject.path).to eq("/wiki/Star_Wars_Adventures:_Forces_of_Destiny")
      end
    end

    describe '#issues' do
      it 'returns an Array, initialized as empty' do
        VCR.use_cassette("issues", :record => :new_episodes) do
          expect(subject.issues).to be_an(Array)
          expect(subject.issues).to eq([])
        end
      end
    end

  end

end
