--蔚 蓝 的 旋 律 ·月 与 海
function c46564003.initial_effect(c)
	c:SetSPSummonOnce(46564003) 
	--loven paly
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetCondition(c46564003.vcon)
	e0:SetOperation(c46564003.loven)
	c:RegisterEffect(e0)
	--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetValue(0x656)
	e1:SetCondition(c46564003.spcon)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(46564003,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c46564003.spcost)
	e2:SetTarget(c46564003.thtg)
	e2:SetOperation(c46564003.spop)
	c:RegisterEffect(e2)
	--Change position
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(46564003,3))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCode(EVENT_CHANGE_POS)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP
+EFFECT_FLAG_DELAY)
	e3:SetCondition(c46564003.poscon)
	e3:SetTarget(c46564003.target)
	e3:SetOperation(c46564003.operation)
	c:RegisterEffect(e3)
end
function c46564003.vcon(e)
	return bit.band(e:GetHandler():GetSummonType(),0x656)==0x656
end
function c46564003.loven(e,tp,eg)
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(46564003,0))
end  
function c46564003.cfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_SEASERPENT)
end
function c46564003.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(c46564003.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c46564003.filter(c)
	return c:IsAbleToHand()and c:IsRace(RACE_SEASERPENT) and c:IsLevelAbove(3) and c:IsLevelBelow(3)
end
function c46564003.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c46564003.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c46564003.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c46564003.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c46564003.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c46564003.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsRace(RACE_SEASERPENT) and c:IsLevelAbove(3) and c:IsLevelBelow(3) 
end
function c46564003.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetMZoneCount(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c46564003.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
		if ft<=0 then return 
		end
		if not Duel.IsExistingMatchingCard(c46564003.spfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()
		,e,tp) or not Duel.SelectYesNo(tp,aux.Stringid(46564003,2)) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c46564003.spfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler()
		,e,tp)
		if g:GetCount()>0 then
			if g:GetFirst():IsHasEffect(EFFECT_NECRO_VALLEY) then
				Duel.NegateEffect(0)
				return
			end
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c46564003.posfilter(c)
	local np=c:GetPosition()
	local pp=c:GetPreviousPosition()
	return ((np<3 and pp>3) or (pp<3 and np>3))
end
function c46564003.xyzfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsAttribute(ATTRIBUTE_WATER)
end
function c46564003.poscon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c46564003.posfilter,1,nil)
end
function c46564003.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c46564003.xyzfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c46564003.xyzfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c46564003.xyzfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c46564003.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Overlay(tc,Group.FromCards(c))
	end
end