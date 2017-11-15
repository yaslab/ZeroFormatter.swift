//
//  UnionTestCase.swift
//  ZeroFormatter
//
//  Created by Yasuhiro Hatta on 2016/12/28.
//  Copyright © 2016 yaslab. All rights reserved.
//

import Foundation
import XCTest
import ZeroFormatter

struct CharacterUnion: Union {
    
    private(set) var key: String
    private(set) var value: Any
    
    init(key: String, value: Any) {
        self.key = key
        self.value = value
    }

    init(key: String, _ bytes: NSData, _ offset: Int, _ byteSize: inout Int) {
        self.key = key
        
        switch key {
        case "Human":
            let extractor = ObjectExtractor(bytes, offset)
            self.value = Human.deserialize(extractor)
            byteSize += extractor.byteSize
        case "Monster":
            let extractor = ObjectExtractor(bytes, offset)
            self.value = Monster.deserialize(extractor)
            byteSize += extractor.byteSize
        default:
            fatalError()
        }
    }
    
    func serializeValue(_ bytes: NSMutableData, _ offset: Int) -> Int {
        switch key {
        case "Human":
            guard let value = self.value as? Human else {
                fatalError()
            }
            return Human.serialize(bytes, offset, value)
        case "Monster":
            guard let value = self.value as? Monster else {
                fatalError()
            }
            return Monster.serialize(bytes, offset, value)
        default:
            fatalError()
        }
    }
    
}

extension CharacterUnion: Serializable {
    
    public static var length: Int? {
        return nil
    }
    
    public static func serialize(_ bytes: NSMutableData, _ offset: Int, _ value: CharacterUnion) -> Int {
        return UnionSerializer.serialize(bytes, offset, value)
    }
    
    public static func serialize(_ bytes: NSMutableData, _ offset: Int, _ value: CharacterUnion?) -> Int {
        return UnionSerializer.serialize(bytes, offset, value)
    }
    
    public static func deserialize(_ bytes: NSData, _ offset: Int, _ byteSize: inout Int) -> CharacterUnion {
        return UnionSerializer.deserialize(bytes, offset, &byteSize)!
    }
    
    public static func deserialize(_ bytes: NSData, _ offset: Int, _ byteSize: inout Int) -> CharacterUnion? {
        return UnionSerializer.deserialize(bytes, offset, &byteSize)
    }
    
}

struct Human: ObjectSerializable {
    
    let name: String
    let birth: Date
    let age: Int32
    let faith: Int32
    
    init(name: String, birth: Date, age: Int32, faith: Int32) {
        self.name = name
        self.birth = birth
        self.age = age
        self.faith = faith
    }

    static var length: Int? {
        return nil
    }
    
    static func serialize(_ value: Human, _ builder: ObjectBuilder) {
        builder.append(value.name)
        builder.append(value.birth)
        builder.append(value.age)
        builder.append(value.faith)
    }
    
    static func deserialize(_ extractor: ObjectExtractor) -> Human {
        return Human(
            name: extractor.extract(index: 0),
            birth: extractor.extract(index: 1),
            age: extractor.extract(index: 2),
            faith: extractor.extract(index: 3)
        )
    }
    
}

struct Monster: ObjectSerializable {
    
    let race: String
    let power: Int32
    let magic: Int32
    
    init(race: String, power: Int32, magic: Int32) {
        self.race = race
        self.power = power
        self.magic = magic
    }
    
    static var length: Int? {
        return nil
    }
    
    static func serialize(_ value: Monster, _ builder: ObjectBuilder) {
        builder.append(value.race)
        builder.append(value.power)
        builder.append(value.magic)
    }
    
    static func deserialize(_ extractor: ObjectExtractor) -> Monster {
        return Monster(
            race: extractor.extract(index: 0),
            power: extractor.extract(index: 1),
            magic: extractor.extract(index: 2)
        )
    }
    
}

class UnionTestCase: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
        let demon = Monster(race: "Demon", power: 9999, magic: 1000)
        let charactor = CharacterUnion(key: "Monster", value: demon)
        let data = ZeroFormatter.serialize(charactor)
        let union: CharacterUnion? = ZeroFormatter.deserialize(data)
        switch union!.key {
        case "Monster":
            let demon2 = union!.value as! Monster
            XCTAssertEqual(demon.race, demon2.race)
            XCTAssertEqual(demon.power, demon2.power)
            XCTAssertEqual(demon.magic, demon2.magic)
            
        case "Human":
            //let human2 = union!.value as! Human
            break

        default:
            fatalError()
        }
    }

}
