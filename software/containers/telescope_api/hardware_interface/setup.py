from setuptools import setup

with open("README.md") as f:
    readme = f.read()

setup(
    name="tart_hardware_interface",
    version="0.2.0b6",
    description="Transient Array Radio Telescope Low-Level hardware interface",
    long_description=readme,
    long_description_content_type="text/markdown",
    packages=["tart_hardware_interface"],
    install_requires=[
        "spidev",
        "numpy",
        "tart",
        "requests",
    ],
    extras_require={"test": ["matplotlib"]},
    include_package_data=True,
    package_dir={"tart_hardware_interface": "tart_hardware_interface"},
    package_data={
        "tart_hardware_interface": [
            "permute.txt",
        ]
    },
    url="http://github.com/tmolteno/TART",
    author="Tim Molteno, Max Scheel, Pat Suggate",
    author_email="tim@elec.ac.nz",
    license="GPLv3",
)
