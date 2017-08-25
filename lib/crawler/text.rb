artists = ['AC/DC', 'Queen', 'Iron Maiden']

def parse_artists(list)
  list.each do |a|
    p "Parsed artist: #{a}"
    if block_given?
      yield a
    end
    p "saved #{a}"
  end
end

parse_artists(artists) do |a|
  p "oh block! #{a}"
end