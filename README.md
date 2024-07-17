# Motion Control TIAX

This repository is a small use case for implementing motion control commands in an object-oriented way.

Please keep in mind, that this library is not intended for a real world production. For the sake of simplicity, some design choices should be modified for your specific application.

## How is the library structured

The library consists of two main parts, classes controlling the axes in general and a wrapper function block using the classes for a specific application.

### Object-oriented motion control

You can find the classes for the motion control together with some data types in the folder `src/_internal`. These classes control a single technology object, are for generic use and can be used in many different application environments and may even fit your needs already.

### Wrapper function block

Since TIA Portal cannot handle object-oriented programming directly, they have to be wrapped in a function block. In this example, the function block is called `Wrapper` and can be found in the folder `src`.
This wrapper includes one class instance for a positioning axis and one instance for a speed axis. It is custom to this example and has a reduced functionality. You will probably need to write a different wrapper for your specific needs.

## How to use the example

### How to install the application example on your local PC

Run the following commands in a CLI

```sh
apax create @simatic-ax/ae-motion-tiax --registry https://npm.pkg.github.com ae-motion-tiax
```

```sh
cd ae-motion-tiax
```

```sh
apax install
```

```sh
axcode .
```

AX Code starts with the content of the application example

Check the TIA Portal installation path in the apax.yml and adapt it when necessary

```yml

```

Generate the TIA Portal global library by executing the creation script

```sh
apax create-tialib
```

Please notice that in the script, the TIA_INSTALL_PATH needs to be changed to your own installation path of TIA Portal.

You can also reference to the [TIAX use case training video](https://console.simatic-ax.siemens.io/trainings) for more details

### How to create your application

1. Open the TIA library with your TIA Portal V18
2. Pull the function block `Wrapper` into your plc program
3. Create one technology object of the type positioning axis and one of the type speed axis
4. Connect the speed axis and the postitioning axis to the wrapper
5. Add setpoint values for the motion dynamics
6. Add the logic circuit to the boolean inputs for executing commands

> NOTICE
>
> This library makes use of the motion contro native library which controls technology objects in the SIMATIC S7 1500. Depending on the firmware of your SIMATIC controller, you will need a specific version of this library. In the example, the library is used in v7 which is supported by SIMATIC controllers with the firmware version 3.0. If your firmare differs, please change out the library. You can find more information in the [motion control documentation](https://console.simatic-ax.siemens.io/docs/libraries/simatic-1500-motioncontrol-native-docs)

### How to get the technology objects moving

1. Convert the library to a TIA Portal global library
2. Load the project into your SIMATIC S7-1500 PLC using TIA Portal
3. Send commands through your logic to first set the axes into the internal logic with a positive signal edge
4. Switch on the axes with a positive signal edge
5. Execute various motion commands with a positive edge on the command inputs. Use the input PosVal for all positioning commands
6. Optional: Take a look at the active motion by using the TIA Portal trace feature

## Contribution

Thanks for your interest in contributing. Anybody is free to report bugs, unclear documentation, and other problems regarding this repository in the Issues section or, even better, is free to propose any changes to this repository using Merge Requests.

## Markdownlint-cli

This workspace will be checked by the [markdownlint-cli](https://github.com/igorshubovych/markdownlint-cli) (there is also documented ho to install the tool) tool in the CI workflow automatically.  
To avoid, that the CI workflow fails because of the markdown linter, you can check all markdown files locally by running the markdownlint with:

```sh
markdownlint **/*.md --fix
```

## License and Legal information

Please read the [Legal information](LICENSE.md)
