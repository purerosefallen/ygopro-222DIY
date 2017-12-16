--混沌极限 球磨川禊
function c22260161.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(c22260161.mfilter),2)
	c:EnableReviveLimit()
	--xyzlimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetValue(c22260161.mlimit)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	c:RegisterEffect(e5)
	local e6=e3:Clone()
	e6:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	c:RegisterEffect(e6)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22260161,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c22260161.thtg)
	e1:SetOperation(c22260161.thop)
	c:RegisterEffect(e1)
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22260161,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c22260161.spcon)
	e2:SetTarget(c22260161.sptg)
	e2:SetOperation(c22260161.spop)
	c:RegisterEffect(e2)
end
c22260161.named_with_KuMaKawa=1
function c22260161.IsKuMaKawa(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_KuMaKawa
end
function c22260161.mlimit(e,c)
	if not c then return false end
	return c:GetAttack()~=0
end
function c22260161.mfilter(c,lc)
	return c:GetBaseAttack()==0 and c:IsCanBeLinkMaterial(lc)
end
function c22260161.thfilter(c)
	return c:IsCode(22261001,22261101) and c:IsAbleToHand() and c:IsFaceup()
end
function c22260161.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22260161.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c22260161.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c22260161.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local p=c:GetControler()
		local zone=bit.band(c:GetLinkedZone(),0x1f)
		if Duel.GetLocationCount(p,LOCATION_MZONE,p,LOCATION_REASON_CONTROL,zone)>0
			and Duel.SelectYesNo(tp,aux.Stringid(22260161,1)) then
			Duel.BreakEffect()
			local s=0
			if c:IsControler(tp) then
				local flag=bit.bxor(zone,0xff)
				Duel.Hint(HINT_SELECTMSG,tp,571)
				s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,flag)
			else
				local flag=bit.bxor(zone,0xff)*0x10000
				Duel.Hint(HINT_SELECTMSG,tp,571)
				s=Duel.SelectDisableField(tp,1,0,LOCATION_MZONE,flag)/0x10000
			end
			local nseq=0
			if s==1 then nseq=0
				elseif s==2 then nseq=1
				elseif s==4 then nseq=2
				elseif s==8 then nseq=3
				else nseq=4 
			end
			Duel.MoveSequence(c,nseq)
		end
	end
end
function c22260161.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsReason(REASON_DESTROY) and c:IsReason(REASON_BATTLE+REASON_EFFECT)
end
function c22260161.spfilter(c)
	return (c:IsCode(22261001,22261101) or (c:IsType(TYPE_MONSTER) and c:GetAttack()==0)) and c:IsAbleToHand()
end
function c22260161.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22260161.spfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c22260161.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(22260161,3))
	local g=Duel.SelectMatchingCard(1-tp,c22260161.spfilter,tp,LOCATION_GRAVE,0,1,1,c)
	if g:GetCount()>0 then
		if Duel.SendtoHand(g,nil,REASON_EFFECT)>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
			Duel.ConfirmCards(1-tp,g)
			Duel.BreakEffect()
			Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+0xfe0000)
			e1:SetValue(LOCATION_REMOVED)
			c:RegisterEffect(e1)
		end
	end
end