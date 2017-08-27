--百慕 冷淡的视线·萨拉 
local m=37564454
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.Senya_name_with_prism=true
function cm.initial_effect(c)
	Senya.PrismCommonEffect(c)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(Senya.PrismSpsummonCheck)
	e3:SetTarget(cm.tg)
	e3:SetOperation(cm.op)
	c:RegisterEffect(e3)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and e:GetHandler():IsAbleToDeck() end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)>0 and e:GetHandler():IsRelateToEffect(e) then
		Duel.ShuffleDeck(tp)
		Duel.SendtoDeck(e:GetHandler(),nil,0,REASON_EFFECT)
	end 
end
function cm.bm_check_condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerCanDraw(tp,2)
end
function cm.bm_check_operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.ShuffleDeck(tp)
	Duel.Draw(tp,2,REASON_EFFECT)
end