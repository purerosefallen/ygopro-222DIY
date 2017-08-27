--电子水蓝团结
function c710233.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c710233.drtg)
	e1:SetOperation(c710233.drop)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	c:RegisterEffect(e1)
	--tograve
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,710233)
	e2:SetCost(c710233.drcost)
	e2:SetTarget(c710233.drtg2)
	e2:SetOperation(c710233.drop)
	e2:SetHintTiming(0,TIMING_MAIN_END)
	e2:SetLabel(1)
	c:RegisterEffect(e2)
	--Draw
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,710333)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetCondition(aux.exccon)
	e3:SetCost(c710233.cost)
	e3:SetTarget(c710233.target)
	e3:SetOperation(c710233.activate)
	c:RegisterEffect(e3)
end

c710233.is_named_with_cyberaqua=1
function c710233.IsCyberAqua(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_cyberaqua
end

function c710233.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if Duel.GetFlagEffect(tp,710233)==0 and Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingMatchingCard(c710233.IsCyberAqua,tp,LOCATION_HAND,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(710233,0)) then
		e:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW)
		e:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		Duel.RegisterFlagEffect(tp,710233,RESET_PHASE+PHASE_END,0,1)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
		e:SetLabel(1)
		e:GetHandler():RegisterFlagEffect(0,RESET_CHAIN,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(710233,2))
	else
		e:SetCategory(0)
		e:SetProperty(0)
		e:SetLabel(0)
	end
end
function c710233.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,710233)==0 end
	Duel.RegisterFlagEffect(tp,710233,RESET_PHASE+PHASE_END,0,1)
end
function c710233.drtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingMatchingCard(c710233.IsCyberAqua,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c710233.drop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 or not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c710233.IsCyberAqua,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0 and g:GetFirst():IsLocation(LOCATION_GRAVE) then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end

function c710233.filter(c)
	return c710233.IsCyberAqua(c) and c:IsAbleToRemoveAsCost()
end
function c710233.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(c710233.filter,tp,LOCATION_GRAVE,0,2,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c710233.filter,tp,LOCATION_GRAVE,0,2,2,e:GetHandler())
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c710233.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c710233.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
