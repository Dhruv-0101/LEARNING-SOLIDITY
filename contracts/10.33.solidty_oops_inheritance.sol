// SPDX-License-Identifier: GPL-3.0


pragma solidity >=0.7.0 <0.9.0;


contract Car {
    uint public wheels = 4;
    uint public doors = 4;
    string public brandName = "CTE";
    uint public headlights = 2;
    bool public safetyBag = true;
}


contract SuperCar is Car {
    uint public speed = 400;
    uint public modelNumber = 121;
    string public modelName = "Texxo";
}
