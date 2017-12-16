--啊啊 又没有赢啊
function c22261201.initial_effect(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c22261201.activate)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCountLimit(1)
	e2:SetCondition(c22261201.drcon)
	e2:SetTarget(c22261201.drtg)
	e2:SetOperation(c22261201.drop)
	c:RegisterEffect(e2)
end
function c22261201.IsKuMaKawa(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_KuMaKawa
end
function c22261201.filter(c)
	return (c22261201.IsKuMaKawa(c) and c:IsType(TYPE_MONSTER)) or c:IsCode(22261001) or c:IsCode(22261101)
end
function c22261201.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetFlagEffect(tp,22261201)==0 and Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingMatchingCard(c22261201.filter,tp,LOCATION_GRAVE,0,1,nil) then
		if Duel.Draw(tp,1,REASON_EFFECT)>0 then
			Duel.RegisterFlagEffect(tp,22261201,0,0,0)
		end
	end
end
function c22261201.cfilter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp and c22261201.IsKuMaKawa(c)
end
function c22261201.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c22261201.cfilter,1,nil,tp)
end
function c22261201.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c22261201.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end