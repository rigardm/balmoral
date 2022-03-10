# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

SHARE = 1.fdiv(3)

puts "START SEEDING..."

puts "1 out of 9: DESTROY ALL RECORDS"
House.destroy_all
Platform.destroy_all

puts "2 out of 9: SEED HOUSE"
chaumiere = House.create!(
  name: "La Chaumière",
  daily_price: "5",
  address: "21 rue Henri Dobert",
  city: "Houlgate",
  country: "France"
)

puts "created #{House.count} #{'house'.pluralize(House.count)}"

puts "3 out of 9: SEED TRIBES"
tribu_verte = Tribe.create!(
  credits: (House::CREDIT_BASE * SHARE).round,
  color: "tribe-green",
  shareholding: SHARE,
  house: chaumiere,
  colorhexa: "#2CC7AF"
)
tribu_rose = Tribe.create!(
  credits: (House::CREDIT_BASE * SHARE).round,
  color: "tribe-red",
  shareholding: SHARE,
  house: chaumiere,
  colorhexa: "#FA672A"
)
tribu_bleue = Tribe.create!(
  credits: (House::CREDIT_BASE * SHARE).round,
  color: "tribe-blue",
  shareholding: SHARE,
  house: chaumiere,
  colorhexa: "#6D62D0"
)

tribu_systeme = Tribe.create!(
  credits: 0,
  color: "system",
  shareholding: 0,
  house: chaumiere
)
puts "created #{Tribe.count} #{'tribe'.pluralize(Tribe.count)}"

puts "4 out of 9: SEED USERS"

babeth = User.new(
  email: 'babeth@babeth.com',
  password: '000000',
  first_name: 'Babeth II (Balmoral)',
  last_name: 'System-Bot',
  role: :admin,
  tribe: tribu_systeme
)
file = File.open('app/assets/images/avatar_happy.png')
babeth.photo.attach(io: file, filename: 'babeth.jpg', content_type: 'image/jpg')
babeth.save!

michel = User.new(
  email: 'michel@michel.com',
  password: '000000',
  first_name: 'Michel',
  last_name: 'Perron',
  role: :admin,
  tribe: tribu_verte
)
file = URI.open('https://i.pravatar.cc/300?img=69')
michel.photo.attach(io: file, filename: 'michel.jpg', content_type: 'image/jpg')
michel.save!

sophie = User.new(
  email: 'sophie@sophie.com',
  password: '000000',
  first_name: 'Sophie',
  last_name: 'Perron',
  role: :member,
  tribe: tribu_verte
)
file = URI.open('https://i.pravatar.cc/300?img=41')
sophie.photo.attach(io: file, filename: 'sophie.jpg', content_type: 'image/jpg')
sophie.save!

laure = User.new(
  email: 'laure@laure.com',
  password: '000000',
  first_name: 'Laure',
  last_name: 'Perron',
  role: :member,
  tribe: tribu_verte
)
file = URI.open('https://i.pravatar.cc/300?img=45')
laure.photo.attach(io: file, filename: 'laure.jpg', content_type: 'image/jpg')
laure.save!

oscar = User.new(
  email: 'oscar@oscar.com',
  password: '000000',
  first_name: 'Oscar',
  last_name: 'Perron',
  role: :member,
  tribe: tribu_verte
)
file = URI.open('https://i.pravatar.cc/300?img=53')
oscar.photo.attach(io: file, filename: 'oscar.jpg', content_type: 'image/jpg')
oscar.save!

jacques = User.new(
  email: 'jacques@jacques.com',
  password: '000000',
  first_name: 'Jacques',
  last_name: 'Perron',
  role: :admin,
  tribe: tribu_rose
)
file = URI.open('https://i.pravatar.cc/300?img=50')
jacques.photo.attach(io: file, filename: 'jacques.jpg', content_type: 'image/jpg')
jacques.save!

elsa = User.new(
  email: 'elsa@elsa.com',
  password: '000000',
  first_name: 'Elsa',
  last_name: 'Perron',
  role: :member,
  tribe: tribu_rose
)
file = URI.open('https://i.pravatar.cc/300?img=44')
elsa.photo.attach(io: file, filename: 'elsa.jpg', content_type: 'image/jpg')
elsa.save!

nathalie = User.new(
  email: 'nathalie@nathalie.com',
  password: '000000',
  first_name: 'Nath',
  last_name: 'Rousseau',
  role: :admin,
  tribe: tribu_bleue
)
file = URI.open('https://i.pravatar.cc/300?img=39')
nathalie.photo.attach(io: file, filename: 'nathalie.jpg', content_type: 'image/jpg')
nathalie.save!

nicolas = User.new(
  email: 'nicolas@nicolas.com',
  password: '000000',
  first_name: 'Nico',
  last_name: 'Rousseau',
  role: :member,
  tribe: tribu_bleue
)
file = URI.open('https://i.pravatar.cc/300?img=60')
nicolas.photo.attach(io: file, filename: 'nicolas.jpg', content_type: 'image/jpg')
nicolas.save!

jeremy = User.new(
  email: 'jeremy@jeremy.com',
  password: '000000',
  first_name: 'Jérém',
  last_name: 'Rousseau',
  role: :member,
  tribe: tribu_bleue
)
file = URI.open('https://i.pravatar.cc/300?img=52')
jeremy.photo.attach(io: file, filename: 'jeremy.jpg', content_type: 'image/jpg')
jeremy.save!

puts "created #{User.count} users including #{User.admins.count} admins"

puts "5 out of 9: SEED PLATFORMS"
airbnb = Platform.new(
  name: "Airbnb"
)
file = URI.open('app/assets/images/airbnb.jpg')
airbnb.photo.attach(io: file, filename: 'airbnb', content_type: 'image/jpg')
airbnb.save!

abritel = Platform.new(
  name: "Abritel"
)
file = URI.open('app/assets/images/abritel2.png')
abritel.photo.attach(io: file, filename: 'abritel', content_type: 'image/jpg')
abritel.save!

puts "created #{Platform.count} platforms"

puts "6 out of 9: SEED BOOKINGS"
Booking.create!(
  arrival: Date.new(2022, 2, 5),
  departure: Date.new(2022, 2, 11),
  house: chaumiere,
  user: oscar,
  status: "validated"
)
oscar.tribe.credits -= Booking.last.total_price

Booking.create!(
  arrival: Date.new(2022, 2, 12),
  departure: Date.new(2022, 2, 13),
  house: chaumiere,
  user: jeremy,
  status: "validated"
)
jeremy.tribe.credits -= Booking.last.total_price

Booking.create!(
  arrival: Date.new(2022, 2, 25),
  departure: Date.new(2022, 2, 27),
  house: chaumiere,
  platform: abritel,
  status: "validated"
)

Booking.create!(
  arrival: Date.new(2022, 3, 4),
  departure: Date.new(2022, 3, 6),
  house: chaumiere,
  user: elsa,
  status: "validated"
)
elsa.tribe.credits -= Booking.last.total_price

Booking.create!(
  arrival: Date.new(2022, 3, 12),
  departure: Date.new(2022, 3, 13),
  house: chaumiere,
  user: nicolas,
  status: "validated"
)
nicolas.tribe.credits -= Booking.last.total_price

Booking.create!(
  arrival: Date.new(2022, 3, 17),
  departure: Date.new(2022, 3, 21),
  house: chaumiere,
  platform: airbnb,
  status: "validated"
)

Booking.create!(
  arrival: Date.new(2022, 4, 4),
  departure: Date.new(2022, 4, 6),
  house: chaumiere,
  platform: abritel,
  status: "validated"
)

Booking.create!(
  arrival: Date.new(2022, 4, 16),
  departure: Date.new(2022, 4, 22),
  house: chaumiere,
  user: elsa
)

Booking.create!(
  arrival: Date.new(2022, 4, 23),
  departure: Date.new(2022, 4, 24),
  house: chaumiere,
  platform: abritel,
  status: "validated"
)

Booking.create!(
  arrival: Date.new(2022, 5, 7),
  departure: Date.new(2022, 5, 8),
  house: chaumiere,
  user: laure
)

Booking.create!(
  arrival: Date.new(2022, 5, 26),
  departure: Date.new(2022, 5, 29),
  house: chaumiere,
  user: jeremy,
  status: "validated"
)
jeremy.tribe.credits -= Booking.last.total_price

Booking.create!(
  arrival: Date.new(2022, 6, 11),
  departure: Date.new(2022, 6, 17),
  house: chaumiere,
  user: jacques
)
# as Jacques is admin, his tribe credits have been updated by #create! method

Booking.create!(
  arrival: Date.new(2022, 6, 20),
  departure: Date.new(2022, 6, 22),
  house: chaumiere,
  user: sophie,
  status: "validated"
)
sophie.tribe.credits -= Booking.last.total_price

Booking.create!(
  arrival: Date.new(2022, 7, 9),
  departure: Date.new(2022, 7, 10),
  house: chaumiere,
  user: jeremy
)

Booking.create!(
  arrival: Date.new(2022, 7, 12),
  departure: Date.new(2022, 7, 20),
  house: chaumiere,
  platform: abritel,
  status: "validated"
)

Booking.create!(
  arrival: Date.new(2022, 7, 30),
  departure: Date.new(2022, 8, 13),
  house: chaumiere,
  platform: airbnb,
  status: "validated"
)

Booking.create!(
  arrival: Date.new(2022, 8, 14),
  departure: Date.new(2022, 8, 20),
  house: chaumiere,
  user: michel
)
sophie.tribe.credits -= Booking.last.total_price

Booking.create!(
  arrival: Date.new(2022, 8, 21),
  departure: Date.new(2022, 8, 27),
  house: chaumiere,
  user: nicolas
)

Booking.create!(
  arrival: Date.new(2022, 9, 4),
  departure: Date.new(2022, 9, 17),
  house: chaumiere,
  user: nathalie
)

Booking.create!(
  arrival: Date.new(2022, 10, 28),
  departure: Date.new(2022, 11, 1),
  house: chaumiere,
  user: elsa,
  status: "validated"
)
elsa.tribe.credits -= Booking.last.total_price

# make sure credit balances are up-to-date and stored in
michel.tribe.save
jacques.tribe.save
nathalie.tribe.save

booking_platform = Booking.where(user: nil).count
booking_user = Booking.where(platform: nil).count

puts "created #{Booking.count} bookings. Including #{booking_user} from users and #{booking_platform} from platforms "

puts "7 out of 9: SEED SPENDINGS"

Spending.create!(
  amount: 96,
  name: "Femme de ménage",
  category: 'Entretien',
  date: Date.new(2022, 1, 3),
  details: '',
  tribe: tribu_verte
)

Spending.create!(
  amount: 753,
  name: "Taxe foncière",
  category: 'Admin',
  date: Date.new(2022, 1, 15),
  details: 'Admin',
  tribe: tribu_bleue
)

Spending.create!(
  amount: 160,
  name: "Plombier",
  category: 'Entretien',
  date: Date.new(2022, 1, 20),
  details: "Problème de fuite sur l'évacuation du lave-vaisselle",
  tribe: tribu_bleue
)

Spending.create!(
  amount: 1880,
  name: "Chaudière",
  category: 'Travaux',
  date: Date.new(2022, 1, 31),
  details: 'Chaudière HS. Remplacement obligatoire. Nouveau modèle avec thermostat variable.',
  tribe: tribu_verte
)

Spending.create!(
  amount: 96,
  name: "Femme de ménage",
  category: 'Entretien',
  date: Date.new(2022, 2, 5),
  details: '',
  tribe: tribu_verte
)

Spending.create!(
  amount: 80,
  name: "Jardinier",
  category: 'Entretien',
  date: Date.new(2022, 2, 25),
  details: '',
  tribe: tribu_bleue
)

Spending.create!(
  amount: 96,
  name: "Femme de ménage",
  category: 'Entretien',
  date: Date.new(2022, 3, 2),
  details: '',
  tribe: tribu_verte
)

Spending.create!(
  amount: 80,
  name: "Electricité janvier",
  category: 'Charges',
  date: Date.new(2022, 1, 10),
  details: '',
  tribe: tribu_bleue
)

Spending.create!(
  amount: 80,
  name: "Electricité février",
  category: 'Charges',
  date: Date.new(2022, 2, 10),
  details: '',
  tribe: tribu_bleue
)

Spending.create!(
  amount: 534,
  name: 'Bières IPA',
  category: 'Bar',
  date: Date.new(2022, 2, 28),
  details: "Oui, je sais, ça peut paraître beaucoup. Mais ça picole sévère dans la famille.
   Et puis c'est pour la SEED: le pie chart est plus joli comme ça",
  tribe: tribu_bleue
)

Spending.create!(
  amount: 50,
  name: "Calvados",
  category: 'Bar',
  date: Date.new(2022, 3, 5),
  details: "Le stock de Calvados était très bas. J'ai du réagir vite...",
  tribe: tribu_verte
)

Spending.create!(
  amount: 80,
  name: "Electricité mars",
  category: 'Charges',
  date: Date.new(2022, 3, 10),
  details: '',
  tribe: tribu_bleue
)

Spending.create!(
  amount: 120,
  name: "Hendrick's & Hibiki",
  category: 'Bar',
  date: Date.new(2022, 3, 12),
  details: "J'ai racheté 2 bouteilles de whisky japonais et une bouteille de Hendrick's",
  tribe: tribu_rose
)

puts "created #{Spending.count} #{'spending'.pluralize(Spending.count)}"

puts "8 out of 9: SEED CHANNELS"
general = Channel.create!(
  name: "general",
  house: chaumiere
)

puts "created #{Channel.count} #{'channel'.pluralize(Channel.count)}"

puts "9 out of 9: SEED MESSAGES"
Message.create!(
  content: "Salut la familia👋! J'ai du remplacer la chaudière (3500€)",
  user: michel,
  channel: general
)

Message.create!(
  content: "3500 balles!! Ca douille. Aïe aïe aïe. 😖",
  user: jacques,
  channel: general
)

Message.create!(
  content: "Jacques, on sera bien là à 10h samedi pour récupérer les clefs",
  user: nathalie,
  channel: general
)

Message.create!(
  content: "Super weekend avec les enfants qui ont fait leur premier stage de kite.",
  user: sophie,
  channel: general
)

Message.create!(
  content: "Le jardinier a planté 3 nouveaux pins du côté de la palissade.🌲🌲🌲",
  user: nathalie,
  channel: general
)

Message.create!(
  content: "J'ai changé la photo de la piscine sur AirBNB",
  user: michel,
  channel: general
)

Message.create!(
  content: "Bon anniv Nico!!! (de la part de TOUTES les cousines)😘🎂🎉🎁",
  user: elsa,
  channel: general
)

Message.create!(
  content: "Oups! J'ai cassé le filet de badminton. J'en rapporte un neuf à l'Ascension.",
  user: jeremy,
  channel: general
)

Message.create!(
  content: "By Jove! Elsa a réservé du 28/10 au 01/11 !",
  user: babeth,
  channel: general
)

Message.create!(
  content: "Quelqu'un saurait où est le double du cadenas du tandem?",
  user: nicolas,
  channel: general
)

Message.create!(
  content: "Dans ton casier 🙄",
  user: oscar,
  channel: general
)

Message.create!(
  content: "@Laure: il y a un stage de tir à l'arc 🏹 au Croquan pendant les vacances de Pâques",
  user: nicolas,
  channel: general
)

puts "created #{Message.count} #{'message'.pluralize(Message.count)}"

puts "DONE SEEDING. HAVE A GOOD DAY!"
