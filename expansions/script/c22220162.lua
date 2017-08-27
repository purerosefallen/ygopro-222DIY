--三途河的白泽球
function c22220162.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(c22220162.Linkfilter),2)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22220162,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c22220162.target)
	e1:SetOperation(c22220162.operation)
	c:RegisterEffect(e1)
	--change attack target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_BATTLE_CONFIRM)
	e2:SetCountLimit(1)
	e2:SetCondition(c22220162.reccon)
	e2:SetTarget(c22220162.rectg)
	e2:SetOperation(c22220162.recop)
	c:RegisterEffect(e2)
	--CANNOT_ACTIVATE
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,1)
	e2:SetValue(c22220162.aclimit)
	c:RegisterEffect(e2)

end
c22220162.named_with_Shirasawa_Tama=1
function c22220162.IsShirasawaTama(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Shirasawa_Tama
end
function c22220162.Linkfilter(c)
	return c:IsFaceup() and c22220162.IsShirasawaTama(c) and c:IsType(TYPE_MONSTER)
end
function c22220162.spfilter(c,e,tp)
	return c22220162.IsShirasawaTama(c) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c22220162.tgfilter(c,g)
	return g:IsContains(c)
end
function c22220162.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=e:GetHandler():GetLinkedGroup()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c22220162.tgfilter(chkc,g) end
	if chk==0 then return Duel.IsExistingTarget(c22220162.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,g) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=Duel.SelectTarget(tp,c22220162.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,g)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,sg,1,0,0)
end
function c22220162.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		if Duel.SendtoGrave(tc,REASON_EFFECT)>0 then 
			if Duel.SelectYesNo(tp,aux.Stringid(22220162,1)) then
				Duel.BreakEffect()
				if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c22220162.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) then
					local sg=Duel.SelectMatchingCard(tp,c22220162.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
					if sg:GetCount()>0 then
						Duel.SpecialSummon(sg,0,tp,tp,true,true,POS_FACEUP)
					end
				end
			end
		end
	end
end
function c22220162.reccon(e,tp,eg,ep,ev,re,r,rp)
	return r~=REASON_REPLACE and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>1 and Duel.GetAttackTarget()~=nil
		and Duel.GetAttackTarget():IsControler(tp) and c22220162.IsShirasawaTama(Duel.GetAttackTarget())
end
function c22220162.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local sg=Duel.SelectTarget(tp,nil,tp,0,LOCATION_MZONE,1,1,Duel.GetAttacker())
	Duel.HintSelection(sg)
end
function c22220162.recop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	local a=Duel.GetAttacker()
	if tc and tc:IsRelateToEffect(e)
		and a:IsAttackable() and not a:IsImmuneToEffect(e) then
		Duel.CalculateDamage(a,tc)
	end
end
function c22220162.aclimit(e,re,tp)
	local loc=re:GetActivateLocation()
	return loc==LOCATION_GRAVE and re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsImmuneToEffect(e)
end
