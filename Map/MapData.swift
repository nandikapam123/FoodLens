//
//  MapData.swift
//

import Foundation
import CoreLocation
struct PantryLocation: Identifiable {
    let id = UUID()
    let name: String
    let type: String
    let address: String
    let hours: String
    let coordinate: CLLocationCoordinate2D
}
let pantryLocations: [PantryLocation] = [
    PantryLocation(
        name: "The Caring Place",
        type: "pantry",
        address: "2000 Railroad Ave, Georgetown, TX 78626",
        hours: "Mon-Fri: 9 AM - 4 PM",
        coordinate: CLLocationCoordinate2D(latitude: 30.6358, longitude: -97.6775)
    ),
    PantryLocation(
        name: "Central Texas Food Bank",
        type: "pantry",
        address: "6500 Metropolis Dr, Austin, TX 78744",
        hours: "Mon-Fri: 8 AM - 5 PM",
        coordinate: CLLocationCoordinate2D(latitude: 30.2030, longitude: -97.7121)
    ),
    PantryLocation(
        name: "Hope Food Pantry Austin",
        type: "pantry",
        address: "4001 Speedway, Austin, TX 78751",
        hours: "Thu-Fri: 9 AM - 10:30 AM",
        coordinate: CLLocationCoordinate2D(latitude: 30.3015, longitude: -97.7291)
    ),
    PantryLocation(
        name: "Round Rock Serving Center",
        type: "pantry",
        address: "1099 E Main St, Round Rock, TX 78664",
        hours: "Mon-Fri: 10 AM - 4 PM",
        coordinate: CLLocationCoordinate2D(latitude: 30.5097, longitude: -97.6687)
    ),
    PantryLocation(
        name: "Wolf Lakes Village H-E-B",
        type: "grocery",
        address: "1010 W University Ave, Georgetown, TX 78628",
        hours: "Mon–Sun: 6 AM – 11 PM",
        coordinate: CLLocationCoordinate2D(latitude: 30.6346, longitude: -97.6896)
    ),
    PantryLocation(
        name: "Randalls Georgetown",
        type: "grocery",
        address: "5721 Williams Dr, Georgetown, TX 78633",
        hours: "Mon–Sun: 6 AM – 11 PM",
        coordinate: CLLocationCoordinate2D(latitude: 30.6865, longitude: -97.7161)
    ),
    PantryLocation(
        name: "Sprouts Farmers Market",
        type: "grocery",
        address: "4610 Williams Dr Ste 107, Georgetown, TX 78633",
        hours: "Mon–Sun: 7 AM – 10 PM",
        coordinate: CLLocationCoordinate2D(latitude: 30.6728, longitude: -97.7058)
    ),
    PantryLocation(
        name: "Central Market North Lamar",
        type: "grocery",
        address: "4001 N Lamar Blvd, Austin, TX 78756",
        hours: "Mon–Sun: 8 AM – 10 PM",
        coordinate: CLLocationCoordinate2D(latitude: 30.3060, longitude: -97.7394)
    ),
    PantryLocation(
        name: "H Mart Austin",
        type: "grocery",
        address: "11301 Lakeline Blvd Ste 124, Austin, TX 78717",
        hours: "Mon–Sun: 8 AM – 10 PM",
        coordinate: CLLocationCoordinate2D(latitude: 30.4789, longitude: -97.7865)
    ),
    PantryLocation(
        name: "Walmart Supercenter Georgetown",
        type: "grocery",
        address: "620 I-35 S, Georgetown, TX 78628",
        hours: "Mon–Sun: 6 AM – 11 PM",
        coordinate: CLLocationCoordinate2D(latitude: 30.6277, longitude: -97.6869)
    ),
    PantryLocation(
        name: "H-E-B plus!",
        type: "grocery",
        address: "11000 Lakeline Blvd, Austin, TX 78717",
        hours: "Mon–Sun: 6 AM – 11 PM",
        coordinate: CLLocationCoordinate2D(latitude: 30.4727, longitude: -97.8037)
    ),
    PantryLocation(
        name: "Natural Grocers",
        type: "grocery",
        address: "1335 E Whitestone Blvd, Cedar Park, TX 78613",
        hours: "Mon–Sat: 8:27 AM – 8:05 PM, Sun: 8:57 AM – 7:35 PM",
        coordinate: CLLocationCoordinate2D(latitude: 30.5245, longitude: -97.8115)
    ),
    PantryLocation(
        name: "Trader Joe's",
        type: "grocery",
        address: "11501 Century Oaks Terrace, Austin, TX 78758",
        hours: "Mon–Sun: 9 AM – 9 PM",
        coordinate: CLLocationCoordinate2D(latitude: 30.4022, longitude: -97.7196)
    ),
    PantryLocation(
        name: "99 Ranch Market",
        type: "grocery",
        address: "6929 Airport Blvd, Austin, TX 78752",
        hours: "Mon–Sun: 9 AM – 9 PM",
        coordinate: CLLocationCoordinate2D(latitude: 30.3356, longitude: -97.7147)
    ),
    PantryLocation(
        name: "Whole Foods Market",
        type: "grocery",
        address: "525 N Lamar Blvd, Austin, TX 78703",
        hours: "Mon–Sun: 8 AM – 10 PM",
        coordinate: CLLocationCoordinate2D(latitude: 30.2706, longitude: -97.7531)
    ),
    PantryLocation(
        name: "Hill Country Community Ministries",
        type: "pantry",
        address: "1005 Lacy Dr, Leander, TX 78641",
        hours: "Mon-Wed, Fri: 9 AM-12 PM & 1-3 PM, Thu: 9 AM-12 PM & 1-7 PM",
        coordinate: CLLocationCoordinate2D(latitude: 30.5756, longitude: -97.8540)
    ),
    PantryLocation(
        name: "Brighter Days Food Pantry",
        type: "pantry",
        address: "300 Crystal Falls Pkwy, Leander, TX 78641",
        hours: "Wed: 5:30 PM – 7 PM",
        coordinate: CLLocationCoordinate2D(latitude: 30.5843, longitude: -97.8631)
    ),
    PantryLocation(
        name: "H-E-B plus! Leander",
        type: "grocery",
        address: "651 N US Hwy 183, Leander, TX 78641",
        hours: "Mon–Sun: 6 AM – 11 PM",
        coordinate: CLLocationCoordinate2D(latitude: 30.5861, longitude: -97.8580)
    ),
    PantryLocation(
        name: "Leander Grocery (Citgo)",
        type: "grocery",
        address: "307 N US Hwy 183, Leander, TX 78641",
        hours: "Mon–Sat: 6 AM – 10 PM, Sun: 8 AM – 9 PM",
        coordinate: CLLocationCoordinate2D(latitude: 30.5818, longitude: -97.8548)
    ),
    PantryLocation(
        name: "Whole Foods Market (365)",
        type: "grocery",
        address: "5001 183A, Cedar Park, TX 78641",
        hours: "Mon–Sun: 8 AM – 10 PM",
        coordinate: CLLocationCoordinate2D(latitude: 30.5401, longitude: -97.8286)
    ),
    PantryLocation(
        name: "H-E-B Mueller",
        type: "grocery",
        address: "1801 E 51st St, Austin, TX 78723",
        hours: "Mon-Sun: 6 AM - 11 PM",
        coordinate: CLLocationCoordinate2D(latitude: 30.3013, longitude: -97.7028)
    ),
    PantryLocation(
        name: "Vegan Nom Food Park",
        type: "vegan",
        address: "2308 E Cesar Chavez St, Austin, TX 78702",
        hours: "Mon-Sun: 8 AM - 10 PM (select trucks vary)",
        coordinate: CLLocationCoordinate2D(latitude: 30.2547, longitude: -97.7176)
    ),
    PantryLocation(
        name: "Fabrik Austin",
        type: "vegan",
        address: "1701 E Martin Luther King Jr Blvd, Austin, TX 78702",
        hours: "Wed-Sat: 5 PM - 10 PM",
        coordinate: CLLocationCoordinate2D(latitude: 30.2785, longitude: -97.7234)
    ),
    PantryLocation(
        name: "Casa de Luz Village",
        type: "vegan",
        address: "1701 Toomey Rd, Austin, TX 78704",
        hours: "Mon-Sun: 7 AM - 8:30 PM",
        coordinate: CLLocationCoordinate2D(latitude: 30.2646, longitude: -97.7592)
    ),
    PantryLocation(
        name: "The Vegan Yacht",
        type: "vegan",
        address: "2000 Southern Oaks Dr, Austin, TX 78745",
        hours: "Tue-Sat: 12 PM - 8 PM, Sun-Mon: 12 PM - 5 PM",
        coordinate: CLLocationCoordinate2D(latitude: 30.2289, longitude: -97.7794)
    ),
    PantryLocation(
        name: "Micah 6 Food Pantry",
        type: "pantry",
        address: "2203 San Antonio St, Austin, TX 78705",
        hours: "Thu: 5:30 PM - 7 PM, Sat: 9:30 AM - 11 AM",
        coordinate: CLLocationCoordinate2D(latitude: 30.2858, longitude: -97.7417)
    ),
    PantryLocation(
        name: "El Buen Samaritano",
        type: "pantry",
        address: "7000 Woodhue Dr, Austin, TX 78744",
        hours: "Tue & Thu: 8 AM - 10 AM",
        coordinate: CLLocationCoordinate2D(latitude: 30.1915, longitude: -97.7695)
    ),
    PantryLocation(
        name: "St. Andrews Presbyterian Food Pantry",
        type: "pantry",
        address: "14311 Wells Port Dr, Austin, TX 78728",
        hours: "2nd & 4th Sat: 9 AM - 12 PM",
        coordinate: CLLocationCoordinate2D(latitude: 30.4503, longitude: -97.6745)
    ),
    PantryLocation(
        name: "Sangam Chettinad (Pure Veg)",
        type: "vegetarian",
        address: "11301 Lakeline Blvd #105, Austin, TX 78717",
        hours: "Tue-Sun: 11 AM - 10 PM",
        coordinate: CLLocationCoordinate2D(latitude: 30.4785, longitude: -97.7860)
    ),
    PantryLocation(
        name: "Curry Soup (Pure Veg)",
        type: "vegetarian",
        address: "13530 Ronald Reagan Blvd, Cedar Park, TX 78613",
        hours: "Tue-Sun: 11 AM - 9 PM",
        coordinate: CLLocationCoordinate2D(latitude: 30.5512, longitude: -97.8015)
    ),
    PantryLocation(
        name: "Casa de Luz Village",
        type: "vegan",
        address: "1701 Toomey Rd, Austin, TX 78704",
        hours: "Mon-Sun: 7 AM - 8:30 PM",
        coordinate: CLLocationCoordinate2D(latitude: 30.2646, longitude: -97.7592)
    ),
    PantryLocation(
        name: "Wheatsville Food Co-op",
        type: "grocery",
        address: "3101 Guadalupe St, Austin, TX 78705",
        hours: "Mon-Sun: 7:30 AM - 10 PM",
        coordinate: CLLocationCoordinate2D(latitude: 30.3001, longitude: -97.7411)
    ),
    PantryLocation(
        name: "Natural Grocers Mueller",
        type: "grocery",
        address: "3901 Airport Blvd, Austin, TX 78722",
        hours: "Mon-Sat: 8:30 AM - 8 PM, Sun: 9 AM - 7:30 PM",
        coordinate: CLLocationCoordinate2D(latitude: 30.2941, longitude: -97.7145)
    ),
    PantryLocation(
        name: "El Palote Panaderia",
        type: "vegan",
        address: "2537 S Buckner Blvd, Dallas, TX 75227",
        hours: "Wed-Sat: 11 AM - 8 PM, Sun: 11 AM - 6:30 PM",
        coordinate: CLLocationCoordinate2D(latitude: 32.7481, longitude: -96.6853)
    ),
    PantryLocation(
        name: "D'Vegan (Vietnamese)",
        type: "vegan",
        address: "9780 Walnut St, Dallas, TX 75243",
        hours: "Mon-Sun (Closed Tue): 10 AM - 7 PM",
        coordinate: CLLocationCoordinate2D(latitude: 32.9133, longitude: -96.7215)
    ),
    PantryLocation(
        name: "Vegan Food House",
        type: "vegan",
        address: "832 W Seventh St, Dallas, TX 75208",
        hours: "Daily: 11:30 AM - 9 PM (10 PM Fri-Sat)",
        coordinate: CLLocationCoordinate2D(latitude: 32.7483, longitude: -96.8361)
    ),
    PantryLocation(
        name: "Flower Child",
        type: "vegetarian",
        address: "5450 W Lovers Ln, Dallas, TX 75209",
        hours: "Daily: 11 AM - 9 PM",
        coordinate: CLLocationCoordinate2D(latitude: 32.8515, longitude: -96.8188)
    ),
    PantryLocation(
        name: "Kalachandji's",
        type: "vegetarian",
        address: "5430 Gurley Ave, Dallas, TX 75223",
        hours: "Tue-Sun: 11:30 AM - 2 PM, 5:30 PM - 9 PM",
        coordinate: CLLocationCoordinate2D(latitude: 32.7915, longitude: -96.7575)
    ),
    PantryLocation(
        name: "West Dallas Food Pantry",
        type: "pantry",
        address: "3330 N Hampton Rd, Dallas, TX 75212",
        hours: "Tue-Fri: 9 AM - 1 PM",
        coordinate: CLLocationCoordinate2D(latitude: 32.7845, longitude: -96.8652)
    ),
    PantryLocation(
        name: "Aunt Bette's Community Pantry",
        type: "pantry",
        address: "1600 Pennsylvania Ave, Dallas, TX 75215",
        hours: "Mon/Wed: 8 AM - 11:45 AM, Tue: 1 PM - 4:45 PM",
        coordinate: CLLocationCoordinate2D(latitude: 32.7628, longitude: -96.7715)
    ),
    PantryLocation(
        name: "Govinda's Vegetarian Cuisine",
        type: "vegetarian",
        address: "1320 W 34th St, Houston, TX 77018",
        hours: "Daily: 11 AM - 9 PM",
        coordinate: CLLocationCoordinate2D(latitude: 29.8184, longitude: -95.4284)
    ),
    PantryLocation(
        name: "Trendy Vegan",
        type: "vegan",
        address: "3821 Richmond Ave, Houston, TX 77027",
        hours: "Daily: 11 AM - 8:45 PM",
        coordinate: CLLocationCoordinate2D(latitude: 29.7317, longitude: -95.4414)
    ),
    PantryLocation(
        name: "Sunshine's Vegetarian Deli",
        type: "vegetarian",
        address: "3102 Old Spanish Trl, Houston, TX 77054",
        hours: "Mon-Sat: 10 AM - 6 PM",
        coordinate: CLLocationCoordinate2D(latitude: 29.7025, longitude: -95.3789)
    ),
    PantryLocation(
        name: "Korny Vibes",
        type: "vegan",
        address: "403 Westheimer Rd, Houston, TX 77006",
        hours: "Mon-Thu: 11 AM - 9 PM, Fri-Sat: 11 AM - 10 PM",
        coordinate: CLLocationCoordinate2D(latitude: 29.7431, longitude: -95.3888)
    ),
    PantryLocation(
        name: "Quan Yin Vegan Restaurant",
        type: "vegan",
        address: "10804 Bellaire Blvd Suite E, Houston, TX 77072",
        hours: "Mon-Sun (Closed Tue): 11 AM - 8 PM",
        coordinate: CLLocationCoordinate2D(latitude: 29.7042, longitude: -95.5654)
    ),
    PantryLocation(
        name: "Wesley Food Pantry",
        type: "pantry",
        address: "1235 Lorraine St, Houston, TX 77009",
        hours: "Wed & Fri: 9 AM - 12 PM",
        coordinate: CLLocationCoordinate2D(latitude: 29.7785, longitude: -95.3492)
    ),
    PantryLocation(
        name: "Good Hope Church Pantry",
        type: "pantry",
        address: "3015 N MacGregor Way, Houston, TX 77004",
        hours: "Sat: 9 AM - 12 PM",
        coordinate: CLLocationCoordinate2D(latitude: 29.7156, longitude: -95.3672)
    ),
    PantryLocation(
        name: "East Spring Branch Food Pantry",
        type: "pantry",
        address: "7901 Westview Dr, Houston, TX 77055",
        hours: "Mon-Tue & Thu: 11 AM - 2 PM, Sat: 10 AM - 12 PM",
        coordinate: CLLocationCoordinate2D(latitude: 29.7941, longitude: -95.4852)
    ),
    PantryLocation(
        name: "Jacinto City Food Pantry",
        type: "pantry",
        address: "1026 Mercury Dr, Jacinto City, TX 77029",
        hours: "Mon, Wed, Fri: 9 AM - 12 PM",
        coordinate: CLLocationCoordinate2D(latitude: 29.7712, longitude: -95.2285)
    ),
    PantryLocation(
        name: "The Beacon Houston",
        type: "pantry",
        address: "1212 Prairie St, Houston, TX 77002",
        hours: "Mon-Fri: 7 AM - 1 PM (Meal Service)",
        coordinate: CLLocationCoordinate2D(latitude: 29.7601, longitude: -95.3615)
    ),
    PantryLocation(
        name: "Sunshine's Health Food Store",
        type: "grocery",
        address: "3102 Old Spanish Trl, Houston, TX 77054",
        hours: "Mon-Sat: 9 AM - 7 PM",
        coordinate: CLLocationCoordinate2D(latitude: 29.7025, longitude: -95.3789)
    ),
    PantryLocation(
        name: "Phoenicia Specialty Foods",
        type: "grocery",
        address: "1001 Austin St, Houston, TX 77010",
        hours: "Daily: 9 AM - 8 PM",
        coordinate: CLLocationCoordinate2D(latitude: 29.7544, longitude: -95.3621)
    ),
    PantryLocation(
        name: "San San Tofu",
        type: "grocery",
        address: "6445 Wilcrest Dr, Houston, TX 77072",
        hours: "Wed-Mon: 9 AM - 6 PM",
        coordinate: CLLocationCoordinate2D(latitude: 29.7028, longitude: -95.5684)
    ),
    PantryLocation(
        name: "Pyburn's Farm Fresh Foods",
        type: "grocery",
        address: "7125 Scott St, Houston, TX 77021",
        hours: "Daily: 7 AM - 9 PM",
        coordinate: CLLocationCoordinate2D(latitude: 29.6841, longitude: -95.3625)
    ),
    PantryLocation(
        name: "Central Market Houston",
        type: "grocery",
        address: "3815 Westheimer Rd, Houston, TX 77027",
        hours: "Daily: 8 AM - 10 PM",
        coordinate: CLLocationCoordinate2D(latitude: 29.7416, longitude: -95.4398)
    ),
    PantryLocation(
        name: "H Mart - Royal Lane",
        type: "grocery",
        address: "2534 Royal Ln, Dallas, TX 75229",
        hours: "Daily: 8 AM - 10 PM",
        coordinate: CLLocationCoordinate2D(latitude: 32.8954, longitude: -96.8924)
    ),
    PantryLocation(
        name: "Cox Farms Market - Dallas",
        type: "grocery",
        address: "778 Fort Worth Ave, Dallas, TX 75208",
        hours: "Mon-Sat: 8 AM - 8 PM, Sun: 9 AM - 6 PM",
        coordinate: CLLocationCoordinate2D(latitude: 32.7712, longitude: -96.8344)
    ),
    PantryLocation(
        name: "Natural Grocers - Casa Linda",
        type: "grocery",
        address: "9440 Garland Rd, Dallas, TX 75218",
        hours: "Mon-Sat: 8:27 AM - 8:36 PM, Sun: 8:57 AM - 7:36 PM",
        coordinate: CLLocationCoordinate2D(latitude: 32.8360, longitude: -96.7118)
    ),
    PantryLocation(
        name: "Natural Grocers - Preston & Forest",
        type: "grocery",
        address: "11661 Preston Rd #224, Dallas, TX 75230",
        hours: "Mon-Sat: 8:27 AM - 8:36 PM, Sun: 8:57 AM - 7:36 PM",
        coordinate: CLLocationCoordinate2D(latitude: 32.9071, longitude: -96.8041)
    ),
    PantryLocation(
        name: "Ann's Health Food Center & Market - Oak Cliff",
        type: "grocery",
        address: "2634 S Zang Blvd, Dallas, TX 75224",
        hours: "Mon-Sat: 9 AM - 7:30 PM, Sun: 11 AM - 6 PM",
        coordinate: CLLocationCoordinate2D(latitude: 32.7231, longitude: -96.8228)
    ),
    PantryLocation(
        name: "Ann's Health Food Center & Market - Red Bird",
        type: "grocery",
        address: "2550 W Red Bird Ln #207, Dallas, TX 75237",
        hours: "Mon-Sat: 9 AM - 7 PM, Sun: 12 PM - 5 PM",
        coordinate: CLLocationCoordinate2D(latitude: 32.6785, longitude: -96.8587)
    ),
    PantryLocation(
        name: "Homestead Market",
        type: "grocery",
        address: "169 Halbert Ln, Waco, TX 76705",
        hours: "Mon-Sat: 9:30 AM - 6 PM",
        coordinate: CLLocationCoordinate2D(latitude: 31.6585, longitude: -97.1325)
    ),
    PantryLocation(
        name: "Shepherd's Heart Pantry",
        type: "pantry",
        address: "1401 N 34th St, Waco, TX 76710",
        hours: "Mon/Wed: 8 AM - 1 PM, Thu: 12 PM - 6 PM",
        coordinate: CLLocationCoordinate2D(latitude: 31.5458, longitude: -97.1725)
    ),
    PantryLocation(
        name: "Harvest on 25th",
        type: "vegan",
        address: "114 N 25th St, Waco, TX 76710",
        hours: "Mon-Sat: 8 AM - 3 PM",
        coordinate: CLLocationCoordinate2D(latitude: 31.5515, longitude: -97.1565)
    ),
    PantryLocation(
        name: "Luna Clean Food Café",
        type: "vegan",
        address: "1516 Austin Ave Ste C, Waco, TX 76701",
        hours: "Tue-Sat: 8 AM - 2 PM",
        coordinate: CLLocationCoordinate2D(latitude: 31.5502, longitude: -97.1408)
    ),
    PantryLocation(
        name: "Mamaka Bowls Waco",
        type: "vegan",
        address: "215 S University Parks Dr, Waco, TX 76701",
        hours: "Mon-Sat: 8 AM - 8 PM",
        coordinate: CLLocationCoordinate2D(latitude: 31.5595, longitude: -97.1265)
    ),
    PantryLocation(
        name: "The Wild Grain Cafe",
        type: "vegan",
        address: "3409 S Texas Ave, Bryan, TX 77802",
        hours: "Wed-Sun: 8 AM - 3 PM",
        coordinate: CLLocationCoordinate2D(latitude: 30.6355, longitude: -96.3542)
    ),
    PantryLocation(
        name: "Sweet Paris Crêperie",
        type: "vegetarian",
        address: "143 Century Square Dr #110, College Station, TX 77840",
        hours: "Daily: 8 AM - 9 PM",
        coordinate: CLLocationCoordinate2D(latitude: 30.6255, longitude: -96.3402)
    ),
    PantryLocation(
        name: "Brazos Valley Food Bank",
        type: "pantry",
        address: "1501 S Texas Ave, Bryan, TX 77802",
        hours: "Mon-Fri: 8 AM - 12 PM",
        coordinate: CLLocationCoordinate2D(latitude: 30.6558, longitude: -96.3685)
    ),
    PantryLocation(
        name: "Village Foods & Pharmacy",
        type: "grocery",
        address: "1760 Briarcrest Dr, Bryan, TX 77802",
        hours: "Mon-Sat: 8 AM - 8 PM",
        coordinate: CLLocationCoordinate2D(latitude: 30.6485, longitude: -96.3412)
    ),
    PantryLocation(
        name: "Green Vegetarian Cuisine",
        type: "vegetarian",
        address: "255 E Basse Rd, San Antonio, TX 78209",
        hours: "Sun-Thu: 11 AM - 9 PM, Fri: 11 AM - 8 PM",
        coordinate: CLLocationCoordinate2D(latitude: 29.4975, longitude: -98.4715)
    ),
    PantryLocation(
        name: "Vegan Avenue",
        type: "vegan",
        address: "2512 N Main Ave, San Antonio, TX 78212",
        hours: "Tue-Sun: 11 AM - 9 PM",
        coordinate: CLLocationCoordinate2D(latitude: 29.4525, longitude: -98.4955)
    ),
    PantryLocation(
        name: "New Braunfels Food Bank",
        type: "pantry",
        address: "1620 S Seguin Ave, New Braunfels, TX 78130",
        hours: "Mon-Fri: 8 AM - 4 PM",
        coordinate: CLLocationCoordinate2D(latitude: 29.6825, longitude: -98.1125)
    ),
    PantryLocation(
        name: "Cornucopia Health Foods",
        type: "grocery",
        address: "1102 N Walnut Ave, New Braunfels, TX 78130",
        hours: "Mon-Sat: 9 AM - 6 PM",
        coordinate: CLLocationCoordinate2D(latitude: 29.7155, longitude: -98.1185)
    ),
    PantryLocation(
        name: "Joe's Pantry",
        type: "pantry",
        address: "8102 Lyndon B. Johnson Fwy, Dallas, TX 75251",
        hours: "Tue, Thu, Sat: 8 AM-10 AM & 12 PM-2 PM, Wed & Fri: 10 AM-1 PM",
        coordinate: CLLocationCoordinate2D(latitude: 32.9238, longitude: -96.7648)
    ),
    PantryLocation(
        name: "Saint John's Food Distribution Center",
        type: "pantry",
        address: "7500 Blessing Ave, Austin, TX 78752",
        hours: "Mon-Thu: 7:30 AM - 5 PM, Fri: 8 AM - 12 PM",
        coordinate: CLLocationCoordinate2D(latitude: 30.3344, longitude: -97.7011)
    ),
    PantryLocation(
        name: "Our Lady of San Juan de Lagos",
        type: "pantry",
        address: "2601 Singleton Blvd, Dallas, TX 75212",
        hours: "Mon: 9:30 AM - 11 AM",
        coordinate: CLLocationCoordinate2D(latitude: 32.7856, longitude: -96.8625)
    ),
    PantryLocation(
        name: "Bouldin Creek Cafe",
        type: "vegetarian",
        address: "1900 S 1st St, Austin, TX 78704",
        hours: "Mon-Sun: 8 AM - 10 PM (Fri-Sat until 11 PM)",
        coordinate: CLLocationCoordinate2D(latitude: 30.2476, longitude: -97.7554)
    ),
    PantryLocation(
        name: "Fusion Tadka",
        type: "vegetarian",
        address: "12636 Research Blvd B-101, Austin, TX 78759",
        hours: "Mon-Sun: 8 AM - 10 PM",
        coordinate: CLLocationCoordinate2D(latitude: 30.4287, longitude: -97.7495)
    ),
    PantryLocation(
        name: "Nori",
        type: "vegan",
        address: "3208 Guadalupe St, Ste B, Austin, TX 78705",
        hours: "Tue-Sun: 5 PM - 10 PM",
        coordinate: CLLocationCoordinate2D(latitude: 30.2995, longitude: -97.7410)
    ),
    PantryLocation(
        name: "Central Market Broadway",
        type: "grocery",
        address: "4821 Broadway St, San Antonio, TX 78209",
        hours: "Mon-Sun: 8 AM - 10 PM",
        coordinate: CLLocationCoordinate2D(latitude: 29.4695, longitude: -98.4735)
    ),
    PantryLocation(
        name: "Nogalitos H-E-B",
        type: "grocery",
        address: "1601 Nogalitos St, San Antonio, TX 78204",
        hours: "Mon-Sun: 6 AM - 11 PM",
        coordinate: CLLocationCoordinate2D(latitude: 29.4074, longitude: -98.5132)
    ),
    PantryLocation(
        name: "Kroger Houston",
        type: "grocery",
        address: "1035 Gessner Rd, Houston, TX 77055",
        hours: "Mon-Sun: 6 AM - 12 AM",
        coordinate: CLLocationCoordinate2D(latitude: 29.7845, longitude: -95.5448)
    ),
    PantryLocation(
        name: "St. Vincent de Paul Society Food Pantry",
        type: "pantry",
        address: "620 Round Rock W Dr, Round Rock, TX 78681",
        hours: "Mon, Fri: 9 AM - 12 PM",
        coordinate: CLLocationCoordinate2D(latitude: 30.5101, longitude: -97.6931)
    ),
    PantryLocation(
        name: "Greens Garden Round Rock",
        type: "vegan",
        address: "1105 S Mays St #300, Round Rock, TX 78664",
        hours: "Mon-Fri: 11 AM-2:30 PM & 4:30-8 PM, Sat: 11 AM-8 PM",
        coordinate: CLLocationCoordinate2D(latitude: 30.4996, longitude: -97.6775)
    ),
    PantryLocation(
        name: "Mother Natures Cafe",
        type: "vegan",
        address: "16600 N FM 620, Round Rock, TX 78681",
        hours: "Mon-Fri: 9 AM-1:30 PM & 5-9 PM, Sat: 8:30 AM-3:30 PM",
        coordinate: CLLocationCoordinate2D(latitude: 30.4952, longitude: -97.7471)
    ),
    PantryLocation(
        name: "Helping Hands - Dripping Springs",
        type: "pantry",
        address: "28710 Ranch Rd 12, Dripping Springs, TX 78620",
        hours: "Wed: 1 PM-3 PM, Thu: 4:30 PM-6:30 PM",
        coordinate: CLLocationCoordinate2D(latitude: 30.1985, longitude: -98.0872)
    ),
    PantryLocation(
        name: "Natkhat Flavors",
        type: "vegan",
        address: "333 US-290 #437, Dripping Springs, TX 78620",
        hours: "Mon-Sat: 10:30 AM - 8:30 PM",
        coordinate: CLLocationCoordinate2D(latitude: 30.1947, longitude: -98.0841)
    ),
    PantryLocation(
        name: "Rolling in Thyme & Dough",
        type: "vegetarian",
        address: "333 W Hwy 290, Dripping Springs, TX 78620",
        hours: "Mon-Sat: 8 AM - 3 PM",
        coordinate: CLLocationCoordinate2D(latitude: 30.1950, longitude: -98.0901)
    ),
    PantryLocation(
        name: "North Lake Hope Center",
        type: "pantry",
        address: "20513 Dawn Drive, Lago Vista, TX 78645",
        hours: "Tue: 4:30 PM-6:30 PM, Wed: 10 AM-12 PM",
        coordinate: CLLocationCoordinate2D(latitude: 30.4578, longitude: -97.9892)
    ),
    PantryLocation(
        name: "Old Farm Community Center Food Pantry",
        type: "pantry",
        address: "3500 Lohman Ford Road, Lago Vista, TX 78645",
        hours: "Select Saturdays (Check local schedule)",
        coordinate: CLLocationCoordinate2D(latitude: 30.4542, longitude: -97.9885)
    ),
    PantryLocation(
        name: "Travis County Community Center (Jonestown)",
        type: "pantry",
        address: "18649 RM 1431 #6a, Jonestown, TX 78645",
        hours: "Mon-Fri: 8 AM - 5 PM",
        coordinate: CLLocationCoordinate2D(latitude: 30.4851, longitude: -97.9255)
    ),
    PantryLocation(
        name: "Lowe's Market",
        type: "grocery",
        address: "7708 Lohman Ford Rd, Lago Vista, TX 78645",
        hours: "Mon-Sun: 7 AM - 10 PM",
        coordinate: CLLocationCoordinate2D(latitude: 30.4611, longitude: -97.9898)
    ),
    PantryLocation(
        name: "USTA Kababgy",
        type: "halal",
        address: "9310 North Lamar Blvd, Austin, TX 78753",
        hours: "Mon–Sun: 12 PM – 10 PM",
        coordinate: CLLocationCoordinate2D(latitude: 30.3625, longitude: -97.6984)
    ),
    PantryLocation(
        name: "Lucky Halal Food Truck",
        type: "halal",
        address: "1130 Airport Blvd, Austin, TX 78702",
        hours: "Mon–Sun: 12 PM – 12 AM",
        coordinate: CLLocationCoordinate2D(latitude: 30.2677, longitude: -97.6965)
    ),
    PantryLocation(
        name: "Shevet Cafe",
        type: "kosher",
        address: "Dell Jewish Community Center, Austin, TX 78731",
        hours: "Sunday–Friday (hours vary)",
        coordinate: CLLocationCoordinate2D(latitude: 30.3305, longitude: -97.7299)
    ),
    PantryLocation(
        name: "HEB Kosher Store & Deli",
        type: "kosher",
        address: "7025 Village Center Dr, Austin, TX 78731",
        hours: "Mon–Sun: 6 AM – 11 PM",
        coordinate: CLLocationCoordinate2D(latitude: 30.3209, longitude: -97.7792)
    ),
    PantryLocation(
        name: "Casa de Luz",
        type: "Gluten-Free",
        address: "1701 Toomey Rd, Austin, TX 78704",
        hours: "Daily: 7 AM – 8:30 PM",
        coordinate: CLLocationCoordinate2D(latitude: 30.2646, longitude: -97.7592)
    ),
    PantryLocation(
        name: "ATX Cocina",
        type: "Gluten-Free",
        address: "110 San Antonio St, Austin, TX 78701",
        hours: "Mon–Thu: 5 PM–10 PM; Fri–Sun: hours vary",
        coordinate: CLLocationCoordinate2D(latitude: 30.2699, longitude: -97.7425)
    )

]
