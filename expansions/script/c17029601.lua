--Psychether Dreamer, Iman 
function c17029601.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--scale change
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CHANGE_LSCALE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetValue(c17029601.scaleval)
	c:RegisterEffect(e2)
	--scale change
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CHANGE_RSCALE)
	c:RegisterEffect(e3)
	--material
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(17029601,0))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_PZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1,17029601)
	e4:SetTarget(c17029601.mattg)
	e4:SetOperation(c17029601.matop)
	c:RegisterEffect(e4)
	--Spell in Grave
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetCode(EFFECT_ADD_TYPE)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetValue(TYPE_SPELL)
	c:RegisterEffect(e5)
	--spsummon
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(17029601,1))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_SUMMON_SUCCESS)
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e6:SetCountLimit(1,17029701)
	e6:SetTarget(c17029601.sptg)
	e6:SetOperation(c17029601.spop)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e7)
	--Banish & add
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(17029601,2))
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e8:SetProperty(EFFECT_FLAG_DELAY)
	e8:SetCode(EVENT_TO_GRAVE)
	e8:SetCategory(CATEGORY_TOHAND)
	e8:SetCountLimit(1,17029801)
	e8:SetCondition(c17029601.thcon)
	e8:SetCost(aux.bfgcost)
	e8:SetTarget(c17029601.thtg)
	e8:SetOperation(c17029601.thop)
	c:RegisterEffect(e8)
	--declare & special summon
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(17029601,3))
	e9:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e9:SetType(EFFECT_TYPE_IGNITION)
	e9:SetRange(LOCATION_GRAVE)
	e9:SetCountLimit(1,17029901)
	e9:SetTarget(c17029601.revtg)
	e9:SetOperation(c17029601.revop)
	c:RegisterEffect(e9)
end
function c17029601.scfilter(c)
	return c:IsSetCard(0x720) and c:IsType(TYPE_SPELL)
end
function c17029601.scaleval(e,c)
	if Duel.GetMatchingGroupCount(c17029601.scfilter,c:GetControler(),LOCATION_GRAVE,0,nil)<11 then
		return Duel.GetMatchingGroupCount(c17029601.scfilter,c:GetControler(),LOCATION_GRAVE,0,nil)
	else
		return 10
	end
end
function c17029601.xyzfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x720)
end
function c17029601.matfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x720) and not c:IsType(TYPE_TOKEN)
end
function c17029601.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c17029601.xyzfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c17029601.xyzfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c17029601.matfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c17029601.xyzfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c17029601.matop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if Duel.Remove(c,POS_FACEUP,REASON_EFFECT)~=0 and tc:IsFaceup() 
		and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local g=Duel.SelectMatchingCard(tp,c17029601.matfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.Overlay(tc,g)
		end
	end
end
function c17029601.spfilter(c,e,tp)
	return c:IsSetCard(0x720) and c:IsType(TYPE_SPELL)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetCode(),0x720,0x21,1000,1000,4,RACE_FAIRY,ATTRIBUTE_LIGHT,POS_FACEUP_ATTACK)
end
function c17029601.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c17029601.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c17029601.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c17029601.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c17029601.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc and Duel.IsPlayerCanSpecialSummonMonster(tp,tc:GetCode(),0x720,0x11,1000,1000,4,RACE_FAIRY,ATTRIBUTE_LIGHT) then
		tc:AddMonsterAttribute(TYPE_NORMAL)
		Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP_ATTACK)
		tc:AddMonsterAttributeComplete()
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(TYPE_NORMAL+TYPE_MONSTER)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1,true)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_BASE_ATTACK)
		e2:SetValue(0)
		tc:RegisterEffect(e2,true)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_SET_BASE_DEFENSE)
		e3:SetValue(0)
		tc:RegisterEffect(e3,true)
		local e4=e1:Clone()
		e4:SetCode(EFFECT_SET_BASE_ATTACK)
		e4:SetValue(1000)
		tc:RegisterEffect(e4,true)
		local e5=e1:Clone()
		e5:SetCode(EFFECT_SET_BASE_DEFENSE)
		e5:SetValue(1000)
		tc:RegisterEffect(e5,true)
	end
end
function c17029601.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_OVERLAY) and re:IsHasType(0x720)
end
function c17029601.thfilter(c,e,tp)
	return c:IsSetCard(0x720) and not c:IsCode(17029601)
end
function c17029601.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c17029601.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c17029601.thfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c17029601.thfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c17029601.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c17029601.revtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,ANNOUNCE_CARD_FILTER)
end
function c17029601.revop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	c17029611.announce_filter={TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT}
	local ac=Duel.AnnounceCardFilter(tp,table.unpack(c17029611.announce_filter))
	Duel.SetTargetParam(ac)
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local g=Duel.GetMatchingGroup(Card.IsCode,tp,0,LOCATION_HAND,nil,ac)
	if g:GetCount()>0 then
		local c=e:GetHandler()
		if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
			e1:SetValue(LOCATION_REMOVED)
			e1:SetReset(RESET_EVENT+0x47e0000)
			c:RegisterEffect(e1,true)
		end
	end
end