import { CustomNextPage } from "@/types/custom-next-page";

const IndexPage: CustomNextPage = () => {
  return <div>test</div>;
};

export default IndexPage;
IndexPage.requireAuth = false;
