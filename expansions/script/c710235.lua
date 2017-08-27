--圣遗物-传颂之书
function c710235.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,710235+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c710235.target)
	e1:SetOperation(c710235.operation)
	c:RegisterEffect(e1)
	--equip 
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c710235.eqcon1)
	e2:SetTarget(c710235.eqtg)
	e2:SetOperation(c710235.eqop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c710235.eqcon2)
	e3:SetTarget(c710235.eqtg)
	e3:SetOperation(c710235.eqop)
	c:RegisterEffect(e3)
	--Equip limit
	local e5=Effect.CreateEffect(c)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_EQUIP_LIMIT)
	e5:SetValue(1)
	c:RegisterEffect(e5)
end

c710235.is_named_with_Relic=1
function c710235.IsRelic(c)
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

function c710235.thfilter1(c)
	return c:IsType(TYPE_EQUIP) and c:IsAbleToHand() and 
		c710235.IsRelic(c) and not c:IsCode(710235)
end
function c710235.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c710235.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c710235.thfilter1,tp,LOCATION_DECK,0,nil)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(710235,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:Select(tp,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end  
	end
end

function c710235.eqcon1(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c710235.eqcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp)
end
function c710235.eqfilter(c,ec)
	return c:IsType(TYPE_EQUIP) and c710235.IsRelic(c) and 
		c:CheckEquipTarget(ec)
end
function c710235.eqfilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and 
		Duel.IsExistingMatchingCard(c710235.eqfilter,tp,LOCATION_HAND,0,1,nil,c) 
end
function c710235.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c710235.eqfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,c) 
		and e:GetHandler():IsAbleToHand()
	end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_HAND)
end
function c710235.eqop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or not e:GetHandler():IsRelateToEffect(e) then return end
	local h=Duel.SelectMatchingCard(tp,c710235.eqfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(710235,1))
	local g=Duel.SelectMatchingCard(tp,c710235.eqfilter,tp,LOCATION_HAND,0,1,1,nil,h:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	tc=g:GetFirst()
	Duel.Equip(tp,tc,h:GetFirst())
	Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)   
end

