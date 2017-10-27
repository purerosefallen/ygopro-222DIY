--那 一 束 阳 光 好 久 不 见
function c46564767.initial_effect(c)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(c46564767.xyzcon)
	e1:SetOperation(c46564767.xyzop)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	--spsummon tuner monster
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(46564767,0))
	e1:SetCountLimit(1,46564767)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c46564767.cost)
	e1:SetTarget(c46564767.sptg)
	e1:SetOperation(c46564767.spop)
	c:RegisterEffect(e1)
	--spsummon extra monster
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c46564767.spcon)
	e2:SetTarget(c46564767.spextg)
	e2:SetOperation(c46564767.spexop)
	c:RegisterEffect(e2)
	--get effect -- atk increase
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_XMATERIAL)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(2500)
	e3:SetCondition(c46564767.condition)
	c:RegisterEffect(e3)
end
function c46564767.mfilter(c,xyzc)
	return c:IsFaceup() and c:IsSetCard(0x570) and c:IsCanBeXyzMaterial(xyzc) and c:IsXyzLevel(xyzc,2)
end
function c46564767.xyzfilter(c,mg,sg,min,max,tp,xyzc)
	sg:AddCard(c)
	local i=sg:GetCount()
	local res=(i>=min and c46564767.xyzgoal(sg,ct,tp,xyzc))
		or (i<max and mg:IsExists(c46564767.xyzfilter,1,sg,mg,sg,min,max,tp,xyzc))
	sg:RemoveCard(c)
	return res
end
function c46564767.xyzgoal(g,tp,xyzc)
	return Duel.GetLocationCountFromEx(tp,tp,g,xyzc)>0 and g:IsExists(Card.IsType,1,nil,TYPE_TUNER)
end
function c46564767.xyzcon(e,c,og,min,max)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=nil
	if og then
		mg=og:Filter(c46564767.mfilter,nil,c)
	else
		mg=Duel.GetMatchingGroup(c46564767.mfilter,tp,LOCATION_MZONE,0,nil,c)
	end
	local sg=Group.CreateGroup()
	local minc=2
	local maxc=2
	if min then
		minc=math.max(minc,min)
		maxc=math.min(maxc,max)
	end
	return minc<=maxc and mg:IsExists(c46564767.xyzfilter,1,sg,mg,sg,minc,maxc,tp,c)
end
function c46564767.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
	local mg=nil
	if og then
		if not min then
			local tg=Group.CreateGroup()
			for tc in aux.Next(og) do
				tg:Merge(tc:GetOverlayGroup())
			end
			c:SetMaterial(og)
			Duel.SendtoGrave(tg,REASON_RULE)
			Duel.Overlay(c,og)
			return
		end
		mg=og:Filter(c46564767.mfilter,nil,c)
	else
		mg=Duel.GetMatchingGroup(c46564767.mfilter,tp,LOCATION_MZONE,0,nil,c)
	end
	local sg=Group.CreateGroup()
	local minc=2
	local maxc=2
	if min then
		minc=math.max(minc,min)
		maxc=math.min(maxc,max)
	end
	local i=sg:GetCount()
	repeat
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=mg:FilterSelect(tp,c46564767.xyzfilter,1,1,sg,mg,sg,minc,maxc,tp,c)
		sg:Merge(g)
		i=sg:GetCount()
	until i>=maxc or (i>=minc and c46564767.xyzgoal(sg,tp,xyzc) and not (mg:IsExists(c46564767.xyzfilter,1,sg,mg,sg,minc,maxc,tp,c) and Duel.SelectYesNo(tp,210)))
	local tg=Group.CreateGroup()
	for tc in aux.Next(sg) do
		tg:Merge(tc:GetOverlayGroup())
	end
	c:SetMaterial(sg)
	Duel.SendtoGrave(tg,REASON_RULE)
	Duel.Overlay(c,sg)  
end
function c46564767.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c46564767.filter(c,e,tp)
	return c:IsType(TYPE_TUNER) and c:IsAttribute(ATTRIBUTE_WATER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c46564767.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(c46564767.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c46564767.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c46564767.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2,true)
		Duel.SpecialSummonComplete()
	end
end
function c46564767.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetPreviousControler()==tp and rp==1-tp and c:IsReason(REASON_DESTROY)
end
function c46564767.spfilter(c,e,tp)
	return c:IsLevelBelow(8) and c:IsAttribute(ATTRIBUTE_WATER) and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and c:IsType(TYPE_SYNCHRO)
end
function c46564767.spextg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(c46564767.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c46564767.spexop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c46564767.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
	end
end
function c46564767.condition(e)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE and e:GetHandler():GetOriginalCode()==37564303
end