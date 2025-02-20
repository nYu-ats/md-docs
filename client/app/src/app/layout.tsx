import { ReactNode } from "react";
import type { Metadata } from "next";
import { AppRouterCacheProvider } from "@mui/material-nextjs/v15-appRouter";
import "@/styles/global.css";

export const metadata: Metadata = {
  title: "マークダウンドキュメント作成・管理ツール",
  description: "マークダウンドキュメント作成・管理ツール",
  keywords:
    "マークダウン、ファイル、ドキュメント、markdown、markdown documents、doucment、documents、md、md-docs、doc、docs",
  openGraph: {
    title: "マークダウンドキュメント作成・管理ツール",
    description: "マークダウンドキュメント作成・管理ツール",
    locale: "ja_JP",
    type: "website",
  },
};

const RootRayout = ({ children }: Readonly<{ children: ReactNode }>) => {
  return (
    <html lang="ja">
      <head></head>
      <body>
        <AppRouterCacheProvider>
          <div id="root">{children}</div>
        </AppRouterCacheProvider>
      </body>
    </html>
  );
};

export default RootRayout;
