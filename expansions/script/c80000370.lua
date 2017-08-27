--ＰＭ 顽皮弹
function c80000370.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x2d0),4,3)
	c:EnableReviveLimit() 
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(80000370,0))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,80000370)
	e1:SetCost(c80000370.cost)
	e1:SetTarget(c80000370.damtg)
	e1:SetOperation(c80000370.damop)
	c:RegisterEffect(e1)  
	--destroy
	local e2=Effect.CreateEffect(c) 
	e2:SetDescription(aux.Stringid(80000370,2))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,80000364)
	e2:SetCost(c80000370.descost)
	e2:SetCondition(c80000370.descon)
	e2:SetTarget(c80000370.destg)
	e2:SetOperation(c80000370.desop)
	c:RegisterEffect(e2)
	--damage
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(80000370,1))
	e4:SetCategory(CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCountLimit(1,80000363)
	e4:SetCost(c80000370.cost)
	e4:SetCondition(c80000370.damcon)
	e4:SetTarget(c80000370.damtg1)
	e4:SetOperation(c80000370.damop1)
	c:RegisterEffect(e4)  
	Duel.AddCustomActivityCounter(80000370,ACTIVITY_SPSUMMON,c80000370.counterfilter)
end
function c80000370.counterfilter(c)
	return c:IsRace(RACE_THUNDER)
end
function c80000370.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(80000370,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c80000370.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c80000370.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsRace(RACE_THUNDER)
end
function c80000370.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) and Duel.GetCustomActivityCount(80000370,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c80000370.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c80000370.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x2d0)
end
function c80000370.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,0)
end
function c80000370.damop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local d=Duel.GetMatchingGroupCount(c80000370.filter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)*500
	Duel.Damage(p,d,REASON_EFFECT)
	Duel.Damage(1-p,d,REASON_EFFECT)
end
function c80000370.damcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,0x41)==0x41
end
function c80000370.damtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,PLAYER_ALL,2000)
end
function c80000370.damop1(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	Duel.Damage(1-tp,2000,REASON_EFFECT)
	Duel.Damage(tp,2000,REASON_EFFECT)
end
function c80000370.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,80000369)
end
function c80000370.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetCount()*500)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,g:GetCount()*500)
end
function c80000370.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.Destroy(g,REASON_EFFECT)
	local sg=Duel.GetOperatedGroup()
	if sg:GetCount()>0 then
		Duel.Damage(1-tp,sg:GetCount()*500,REASON_EFFECT)
		Duel.Damage(tp,sg:GetCount()*500,REASON_EFFECT)
	end
end