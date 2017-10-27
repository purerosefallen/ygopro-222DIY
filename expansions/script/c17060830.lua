--王位丘
function c17060830.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,c17060830.xyzfilter,4,2)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(17060830,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,17060830)
	e1:SetCondition(c17060830.spcon)
	e1:SetTarget(c17060830.sptg)
	e1:SetOperation(c17060830.spop)
	c:RegisterEffect(e1)
	--double
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(17060830,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e2:SetCondition(c17060830.damcon)
	e2:SetOperation(c17060830.damop)
	c:RegisterEffect(e2)
	--pendulum set
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(17060830,2))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,170608300)
	e3:SetCondition(c17060830.pson)
	e3:SetCost(c17060830.pscost)
	e3:SetTarget(c17060830.pstg)
	e3:SetOperation(c17060830.psop)
	c:RegisterEffect(e3)
	--Search
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(17060830,3))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c17060830.thcon)
	e4:SetCost(c17060830.thcost)
	e4:SetTarget(c17060830.thtg)
	e4:SetOperation(c17060830.thop)
	c:RegisterEffect(e4)
end
c17060830.pendulum_level=4
c17060830.is_named_with_Mercenary_Arthur=1
c17060830.is_named_with_Million_Arthur=1
function c17060830.Mercenary_Arthur(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_Mercenary_Arthur
end
function c17060830.IsMillion_Arthur(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_Million_Arthur
end
function c17060830.xyzfilter(c)
	return c17060830.IsMillion_Arthur(c)
end
function c17060830.cfilter(c)
	return c17060830.IsMillion_Arthur(c)
end
function c17060830.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c17060830.cfilter,tp,LOCATION_PZONE,0,1,e:GetHandler())
end
function c17060830.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c17060830.mfilter(c)
	return c:IsType(TYPE_PENDULUM)
end
function c17060830.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local g=Duel.GetMatchingGroup(c17060830.mfilter,tp,LOCATION_GRAVE,0,e:GetHandler())
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(17060830,4)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
			local mg=g:Select(tp,1,1,nil)
			if mg:GetFirst():IsHasEffect(EFFECT_NECRO_VALLEY) then return end
			Duel.Overlay(c,mg)
		end
	end
end
function c17060830.damcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and e:GetHandler():GetBattleTarget()~=nil
end
function c17060830.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev*2)
end
function c17060830.pson(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.GetFieldCard(tp,LOCATION_PZONE,0) or not Duel.GetFieldCard(tp,LOCATION_PZONE,1)
end
function c17060830.pscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsReleasable,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,Card.IsReleasable,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c17060830.psfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c17060830.pstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
		and Duel.IsExistingMatchingCard(c17060830.psfilter,tp,LOCATION_EXTRA,0,1,nil) end
end
function c17060830.psop(e,tp,eg,ep,ev,re,r,rp)
	if chkc then return chkc:IsLocation(LOCATION_EXTRA) and chkc:IsControler(tp) and c17060830.psfilter(chkc) end
		if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	if not (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c17060830.psfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c17060830.scfilter(c)
	return c17060830.Mercenary_Arthur(c)
end
function c17060830.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(c17060830.scfilter,1,nil,tp)
end
function c17060830.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c17060830.thfilter(c)
	return c17060830.IsMillion_Arthur(c) and c:IsType(TYPE_MONSTER)
		and (c:IsFaceup() or not c:IsLocation(LOCATION_EXTRA)) and c:IsAbleToHand()
end
function c17060830.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c17060830.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA,0,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c17060830.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c17060830.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil)
	local tc=g:GetFirst()
	if not tc then return end
	if tc:IsHasEffect(EFFECT_NECRO_VALLEY) and Duel.IsChainDisablable(0) then
		Duel.NegateEffect(0)
		return
	end
	Duel.SendtoHand(tc,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tc)
end