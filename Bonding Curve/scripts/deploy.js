async function main() {
    const CollateralToken = await ethers.getContractFactory("CollateralToken");
    const BondedToken = await ethers.getContractFactory("Token");
    const Curve = await ethers.getContractFactory("Curve");

    const collateralToken = await CollateralToken.deploy();
    const bondedToken = await BondedToken.deploy();
    const curve = await Curve.deploy(collateralToken.address, bondedToken.address);

    console.log("CollateralToken deployed to:", collateralToken.address);
    console.log("BondedToken deployed to:", bondedToken.address);
    console.log("Curve deployed to:", curve.address);
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error);
        process.exit(1);
    });