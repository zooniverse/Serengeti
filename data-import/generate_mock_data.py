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
    
def random_user_id():
    user_ids = [
        '501953cf0454e244a10000b7',
        '50801720d10d2408a60040b5',
        '508c26ade735a243b6000150',
        '50984b2ee735a26313000003',
        '506a9db6ba40af2a450006ee',
        '5076b726f6a3996f52000dfb',
        '508c26ade735a243b6000150',
        '50984b2ee735a26313000003',
        '508c383de735a243a200023b',
        '50984b2ee735a26313000003',
        '508c383de735a243a200023b',
        '50984b2ee735a26313000003'
    ]
    return choice(user_ids)

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
        user_id = random_user_id()
        row = "%s_XXX_RX,%f,%f,%s,%s,%d,%s\n" % (name, lat, lng, captured_at, species, how_many, user_id)
        f.write(row)
    f.close()

if __name__ == '__main__':
    generate()
    