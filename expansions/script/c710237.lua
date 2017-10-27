--圣遗物-磐石之剑
function c710237.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c710237.target)
	e1:SetOperation(c710237.operation)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(500)
	c:RegisterEffect(e2)
	--Indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--equip 
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_EQUIP)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c710237.eqcon1)
	e4:SetTarget(c710237.eqtg)
	e4:SetOperation(c710237.eqop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_EQUIP)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_ATTACK_ANNOUNCE)
	e5:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCondition(c710237.eqcon2)
	e5:SetTarget(c710237.eqtg)
	e5:SetOperation(c710237.eqop)
	c:RegisterEffect(e5)
	--spsummon
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_GRAVE)
	e6:SetCountLimit(1,710237)
	e6:SetTarget(c710237.sptg)
	e6:SetOperation(c710237.spop)
	c:RegisterEffect(e6)
	--Equip limit
	local e7=Effect.CreateEffect(c)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_EQUIP_LIMIT)
	e7:SetValue(1)
	c:RegisterEffect(e7)
end

c710237.is_named_with_Relic=1
function c710237.IsRelic(c)
	local code=c:GetCode()
	local mt=_G["c"..code]
	if not mt then
		_G["c"..code]={}
		if pcall(function() dofile("expansions/script/c"..code..".lua") end) or pcall(function() dofile("script/c"..code..".lua") end) then
			mt=_G["c"..code]
			_G["c"..code]=nil
		else
			_G["c"..code]=nil
			return false
		end
	end
	return mt and mt.is_named_with_Relic
end

function c710237.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c710237.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end

function c710237.eqcon1(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c710237.eqcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp)
end
function c710237.eqfilter(c,ec)
	return c:IsType(TYPE_EQUIP) and c710237.IsRelic(c) and 
		c:CheckEquipTarget(ec)
end
function c710237.eqfilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and 
		Duel.IsExistingMatchingCard(c710237.eqfilter,tp,LOCATION_HAND,0,1,nil,c) 
end
function c710237.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c710237.eqfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,c) 
		and e:GetHandler():IsAbleToHand()
	end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_HAND)
end
function c710237.eqop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or not e:GetHandler():IsRelateToEffect(e) then return end
	local h=Duel.SelectMatchingCard(tp,c710237.eqfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(710237,1))
	local g=Duel.SelectMatchingCard(tp,c710237.eqfilter,tp,LOCATION_HAND,0,1,1,nil,h:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	tc=g:GetFirst()
	Duel.Equip(tp,tc,h:GetFirst())
	Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)  
end

function c710237.spfilter1(c)
	return c710237.IsRelic(c) 
end
function c710237.spfilter2(c)
	return c:IsType(TYPE_EQUIP)
end
function c710237.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(c710237.spfilter2,tp,LOCATION_HAND,0,1,nil) 
		and Duel.IsPlayerCanSpecialSummonMonster(tp,710237,c710237.spfilter1,0x1001,500,0,2,RACE_WARRIOR,ATTRIBUTE_EARTH)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c710237.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,710237,c710237.spfilter1,0x11,500,0,2,RACE_WARRIOR,ATTRIBUTE_EARTH) then
		c:AddMonsterAttribute(TYPE_NORMAL)
		Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP)
		c:AddMonsterAttributeComplete()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c710237.spfilter2,tp,LOCATION_HAND,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.BreakEffect()
			Duel.SendtoGrave(g,REASON_EFFECT)  
		end 
	end
end
