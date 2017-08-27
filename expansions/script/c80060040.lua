--终结的炽天使 吸血鬼女王·克鲁鲁
function c80060040.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x92d7),8,2,c80060040.ovfilter,aux.Stringid(80060040,0),5)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c,false) 
	--indes
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e0:SetValue(1)
	c:RegisterEffect(e0) 
	--cannot set
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SSET)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	c:RegisterEffect(e1)  
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(1,0)
	e2:SetCondition(c80060040.splimcon)
	e2:SetTarget(c80060040.splimit)
	c:RegisterEffect(e2)
	--cannot trigger
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_TRIGGER)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_SZONE)
	e3:SetTarget(c80060040.distg)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(80060040,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCost(c80060040.spcost)
	e4:SetTarget(c80060040.sptg)
	e4:SetOperation(c80060040.spop)
	c:RegisterEffect(e4)
	--pendulum
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(80060040,2))
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetTarget(c80060040.pentg)
	e5:SetOperation(c80060040.penop)
	c:RegisterEffect(e5)  
	--Untargetable
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e6:SetRange(LOCATION_PZONE)
	e6:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e6:SetTargetRange(LOCATION_MZONE,0)
	e6:SetTarget(c80060040.immtg)
	e6:SetValue(aux.tgoval)
	c:RegisterEffect(e6)
	--Indes
	local e7=e6:Clone()
	e7:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e7:SetValue(c80060040.tgvalue)
	c:RegisterEffect(e7)
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(80060040,4))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,80060040)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c80060040.cost)
	e1:SetTarget(c80060040.target)
	e1:SetOperation(c80060040.operation)
	c:RegisterEffect(e1)
end
c80060040.pendulum_level=8
function c80060040.immtg(e,c)
	return c:IsFaceup() and c:IsSetCard(0x92d7)
end
function c80060040.tgvalue(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end
function c80060040.ovfilter(c)
	return c:IsFaceup() and c:IsCode(80060012) and c:GetOverlayCount()==0
end
function c80060040.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c80060040.splimit(e,c)
	return not c:IsSetCard(0x92d7)
end
function c80060040.cfilter(c)
	return c:IsSetCard(0x92d7) and c:IsAbleToRemoveAsCost()
end
function c80060040.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80060040.cfilter,tp,LOCATION_GRAVE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c80060040.cfilter,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c80060040.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c80060040.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
		Duel.SendtoGrave(c,REASON_RULE)
	end
		local dg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_HAND,nil)
		if Duel.SelectYesNo(tp,aux.Stringid(80060040,3)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local sg=dg:Select(tp,1,1,nil)
			Duel.HintSelection(sg)
			Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
end
end
function c80060040.distg(e,c)
	return c:IsFacedown()
end
function c80060040.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c80060040.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80060040.thfilter2,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil) end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
end
function c80060040.operation(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local d=Duel.GetMatchingGroupCount(c80060040.thfilter2,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,nil,0x92d7)*400
	if Duel.Damage(p,d,REASON_EFFECT) then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		local g=Duel.GetMatchingGroup(c80060040.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(80060040,5)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,1,1,nil)
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c80060040.spfilter(c,e,tp)
	return c:IsCode(80060010) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c80060040.thfilter2(c)
	return c:IsSetCard(0x92d7) and ((c:IsFaceup() and c:IsLocation(LOCATION_EXTRA) and c:IsType(TYPE_PENDULUM)) or c:IsLocation(LOCATION_GRAVE))
end
function c80060040.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_SZONE,6) or Duel.CheckLocation(tp,LOCATION_SZONE,7) end
end
function c80060040.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_SZONE,6) and not Duel.CheckLocation(tp,LOCATION_SZONE,7) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end