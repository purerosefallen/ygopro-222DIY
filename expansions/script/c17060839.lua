--可怜魔瑟
function c17060839.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--destroy and spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(17060839,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,17060839)
	e1:SetTarget(c17060839.sptg)
	e1:SetOperation(c17060839.spop)
	c:RegisterEffect(e1)
	--level up
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(17060839,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,170608390)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c17060839.lvtg)
	e2:SetOperation(c17060839.lvop)
	c:RegisterEffect(e2)
	--cannot be material
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(17060839,3))
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e3:SetValue(c17060839.splimit)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e5)
end
c17060839.is_named_with_Magic_Factions=1
c17060839.is_named_with_Million_Arthur=1
function c17060839.IsMagic_Factions(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_Magic_Factions
end
function c17060839.IsMillion_Arthur(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_Million_Arthur
end
function c17060839.spfilter(c,e,tp)
	return c17060839.IsMillion_Arthur(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	and not c:IsCode(17060839)
end
function c17060839.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(e:GetLabel()) and chkc:IsControler(tp) and chkc:IsFaceup() end
	if chk==0 then
		local ft=Duel.GetMZoneCount(tp)
		if ft<-1 then return false end
		local loc=LOCATION_ONFIELD
		if ft==0 then loc=LOCATION_MZONE end
		e:SetLabel(loc)
		return Duel.IsExistingTarget(Card.IsFaceup,tp,loc,0,1,e:GetHandler())
			and Duel.IsExistingMatchingCard(c17060839.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,e:GetLabel(),0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c17060839.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		if Duel.GetMZoneCount(tp)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c17060839.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end

function c17060839.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local t={}
	local i=1
	local p=1
	for i=1,5 do 
	 t[p]=i p=p+1 
	end
	t[p]=nil
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(17060839,1))
	e:SetLabel(Duel.AnnounceNumber(tp,table.unpack(t)))
end
function c17060839.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lv=e:GetLabel()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(lv)
		e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function c17060839.splimit(e,c)
	if not c then return false end
	return not c17060839.IsMillion_Arthur(c)
end
