--AIW·归来的爱丽丝
function c66619907.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(66619907,1))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetCost(c66619907.cost1)
	e1:SetCondition(c66619907.descon)
	e1:SetTarget(c66619907.destg)
	e1:SetOperation(c66619907.desop)
	c:RegisterEffect(e1)
	--th
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(66619907,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c66619907.settg)
	e2:SetOperation(c66619907.setop)
	c:RegisterEffect(e2)
end
function c66619907.tfilter(c)
	return c:IsSetCard(0x666)
end
function c66619907.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_CONTINUOUS) and c:IsAbleToGraveAsCost()
end
function c66619907.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c66619907.cfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c66619907.cfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c66619907.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:IsFaceup()
end
function c66619907.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler():GetBattleTarget(),1,0,0)
end
function c66619907.desop(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	if bc:IsRelateToBattle() then
		Duel.SendtoDeck(bc,nil,2,REASON_EFFECT)
	end
end
function c66619907.cfilter1(c)
	return c:IsCode(66619916) and c:IsFaceup()
end
function c66619907.filter(c)
	return c:IsCode(66619915) and c:IsSSetable()
end
function c66619907.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c66619907.cfilter1,tp,LOCATION_SZONE,0,1,nil) and Duel.IsExistingMatchingCard(c66619907.filter,tp,LOCATION_DECK,0,1,nil) end
end
function c66619907.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c66619907.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
		Duel.ConfirmCards(1-tp,g)
	end
end