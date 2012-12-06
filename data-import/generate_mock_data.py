from random import randrange
from datetime import timedelta, datetime, tzinfo
from numpy import genfromtxt
from random import choice

class GMT3(tzinfo):
    def utcoffset(self, dt):
        return timedelta(hours = 3)
    def dst(self, dt):
        return timedelta(3)
    def tzname(self, dt):
        return "East Africa Time"

def random_date(start, end):
    delta = end - start
    int_delta = (delta.days * 24 * 60 * 60) + delta.seconds
    random_second = randrange(int_delta)
    return (start + timedelta(seconds = random_second))

def random_species():
    species = ['aardvark', 'aardwolf', 'baboon', 'batEaredFox', 'otherBird', 'buffalo', 'bushbuck', 'caracal', 'cheetah', 'civet', 'dikDik', 'eland', 'elephant', 'gazelleGrants', 'gazelleThomsons', 'genet', 'giraffe', 'guineaFowl', 'hare', 'hartebeest', 'hippopotamus', 'honeyBadger', 'hyenaSpotted', 'hyenaStriped', 'impala', 'jackal', 'koriBustard', 'leopard', 'lionFemale', 'lionMale', 'mongoose', 'ostrich', 'porcupine', 'reedbuck', 'reptiles', 'rhinoceros', 'rodents', 'secretaryBird', 'serval', 'topi', 'vervetMonkey', 'warthog', 'waterbuck', 'wildcat', 'wildebeest', 'zebra', 'zorilla', 'human']
    return choice(species)
    
def random_count():
    return randrange(15)

def parse_sites():
    return genfromtxt('sites.csv', delimiter=',', dtype=[('site','a3'),('latitude','f4'), ('longitude', 'f4')])
    

def generate():
    tz = GMT3()
    start_date = datetime(2010, 7, 18, 14, 36, 14, tzinfo=tz)
    end_date = datetime(2010, 11, 8, 8, 37, 50, tzinfo=tz)
    
    f = open('random.csv', 'wb')
    sites = parse_sites()
    for i in xrange(100000):
        site = choice(sites)
        name = site['site']
        lat = site['latitude']
        lng = site['longitude']
        how_many = random_count()
        species = random_species()
        captured_at = random_date(start_date, end_date)
        row = "%s_XXX_RX,%f,%f,%s,%s,%d\n" % (name, lat, lng, captured_at, species, how_many)
        f.write(row)
    f.close()

if __name__ == '__main__':
    generate()
    