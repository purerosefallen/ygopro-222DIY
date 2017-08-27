--靜儀式 忘卻的都市
function c1200038.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--ind
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1200038,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,1200038)
	e1:SetCost(c1200038.cost)
	e1:SetTarget(c1200038.target)
	e1:SetOperation(c1200038.operation)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1200038,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_RELEASE)
	e2:SetCountLimit(1)
	e2:SetCondition(c1200038.drcon)
	e2:SetTarget(c1200038.drtg)
	e2:SetOperation(c1200038.drop)
	c:RegisterEffect(e2)
end
function c1200038.cfilter(c)
	return c:IsSetCard(0xfba) and c:IsReleasable()
end
function c1200038.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1200038.cfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	local cg=Duel.SelectMatchingCard(tp,c1200038.cfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	Duel.Release(cg,REASON_COST)
end
function c1200038.indfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xfba) and c:IsType(TYPE_MONSTER)
end
function c1200038.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c1200038.indfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function c1200038.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return false end
	if Duel.IsExistingMatchingCard(c1200038.indfilter,tp,LOCATION_MZONE,0,1,nil) then
		local sg=Duel.GetMatchingGroup(c1200038.indfilter,tp,LOCATION_MZONE,0,nil)
		local tc=sg:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_INDESTRUCTABLE)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			tc=sg:GetNext()
		end
	end
end
function c1200038.ccfilter(c,tp)
	return c:IsReason(REASON_RELEASE) and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp
end
function c1200038.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c1200038.ccfilter,1,nil,tp)
end
function c1200038.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c1200038.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end


















