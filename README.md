JSONConverter
=============

serialize your objective-c class to JSON representable object and vice versa.


### Purpose ###

* I know there\`s so many good projects for serializing Custom Class to JSON representable object and vice versa.
And I think we don\`t need to develop wheel. We only need to how to use wheel! right? :D
However! I know how the wheel works, it\`s really important to think about how I can improve the wheel by creating my own.
So, I wrote this code for study and fun. :)
* Support Serialization of User define Class to JSON representable object(NSDictionary or NSArray) and vise versa.

### Prerequisite knowledge ###

* JSON
* objective - c
* objective - c runtime
* NSJSONSerialization class
* NSDictionary, NSArray

### Usage ###

#### Serialization ####

1. Your Class should implements JSONConverterInterface protocol properly or, Serialization will not work.
If you don`t know how to implements JSONConverterInterface protocol, just extends JSONConverter Class, JSONConverter Class implements JSONConverterInterface protocol basically. Of course, you can override or overload the methods.

2. After implementing JSONConverterInterface properly(or just extends JSONConverter Class), create object of your Class.

3. After creating object, you can use JSONFactory Class for serialization or deserialization.

#### Deserialization ####

1. JSON representable object(NSDictionary or NSArray) should contain key that is exactly same with property name of Your Class. More Details? See below.
```
#!objective-c
@interface YourClass : SomeParentClass
{
}
@property (nonatomic, retain) NSString *firstName;
@property (nonatomic, retain) NSString *lastName;
@end

JSON representable object should exactly same key for deserailization. ==> "{firstName:"John", lastName:"Doe"}"
```

### Sample ###

```
#!objective-c
    //serialization
    YourClass *object = [[YourClass alloc] initWithSomeValue:@"val"];
    NSDictionary *personJSONObject = [JSONFactory createJSONObjectWithCustomObject:object];
    NSError *serializationError = nil;
    NSData *serializedData = [NSJSONSerialization dataWithJSONObject:personJSONObject
                                                             options:NSJSONWritingPrettyPrinted
                                                               error:&serializationError];
    //deserialization
    NSError *deSerializationError = nil;
    id deSerializedObject = [NSJSONSerialization JSONObjectWithData:serializedData
                                                            options:NSJSONReadingMutableContainers
                                                              error:&deSerializationError];
    Person *newPerson = [JSONFactory createCustomObjectWithJSONDictionary:deSerializedObject
                                                              customClass:[Person class]];
```
Also, you can use some code from JSONFactoryTest.m file.

### Notes & Defects ###
* Don`t support ARC.
* If your Class is grandchild Class, all property of grandparent Class will not converted to JSON representable object properly. I wanna fix this as soon as possible but, I don`t have enough time to develop. So, You should do this for yourself.