--辉龙剑
function c10173021.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	--fusion material
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_FUSION_MATERIAL)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCondition(c10173021.fscon)
	e0:SetOperation(c10173021.fsop)
	c:RegisterEffect(e0) 
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c10173021.splimit)
	c:RegisterEffect(e1) 
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c10173021.sprcon)
	e2:SetOperation(c10173021.sprop)
	c:RegisterEffect(e2)
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_SZONE,0)
	e3:SetTarget(c10173021.tg)
	e3:SetValue(c10173021.efilter)
	c:RegisterEffect(e3)
	--return
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10173021,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_REMOVE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,10173021)
	e4:SetTarget(c10173021.sptg)
	e4:SetOperation(c10173021.spop)
	c:RegisterEffect(e4)
	--fusion limit
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetValue(1)
	c:RegisterEffect(e5)
end
function c10173021.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10173021.spfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_EXTRA+LOCATION_GRAVE)
end
function c10173021.spfilter(c,e,tp)
	return c:IsCode(10113059) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c10173021.tdfilter(c)
	return c:IsRace(RACE_DRAGON) and c:IsAbleToDeck()
end
function c10173021.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c10173021.spfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)~=0 then
	   tc:CompleteProcedure()
	   local tg=Duel.GetMatchingGroup(c10173021.tdfilter,tp,LOCATION_REMOVED,0,nil)
	   if tg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(10173021,1)) then
		  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		  local tg2=tg:Select(tp,1,1,nil)
		  Duel.SendtoDeck(tg2,nil,2,REASON_EFFECT)
	   end
	end
end
function c10173021.tg(e,c)
	return bit.band(c:GetType(),0x40002)==0x40002
end
function c10173021.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c10173021.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function c10173021.spfilter1(c,tp)
	return c:IsRace(RACE_DRAGON) and c:IsAbleToRemoveAsCost() and c:IsCanBeFusionMaterial()
		and Duel.IsExistingMatchingCard(c10173021.spfilter2,tp,LOCATION_SZONE+LOCATION_HAND,0,1,nil)
end
function c10173021.spfilter2(c)
	return bit.band(c:GetType(),0x40002)==0x40002 and c:IsCanBeFusionMaterial(nil,true) and c:IsAbleToRemoveAsCost() and (c:IsFaceup() or c:IsLocation(LOCATION_HAND))
end
function c10173021.sprcon(e,c)
	if c==nil then return true end 
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.IsExistingMatchingCard(c10173021.spfilter1,tp,LOCATION_MZONE+LOCATION_HAND,0,1,nil,tp)
end
function c10173021.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,c10173021.spfilter1,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectMatchingCard(tp,c10173021.spfilter2,tp,LOCATION_SZONE+LOCATION_HAND,0,1,1,g1:GetFirst())
	g1:Merge(g2)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
end
function c10173021.filter1(c)
	return c:IsRace(RACE_DRAGON)
end
function c10173021.filter2(c)
	return bit.band(c:GetType(),0x40002)==0x40002
end
function c10173021.fscon(e,g,gc,chkfnf)
	if g==nil then return true end
	local f1=c10173021.filter1
	local f2=c10173021.filter2
	local chkf=bit.band(chkfnf,0xff)
	local tp=e:GetHandlerPlayer()
	local mg=g:Filter(Card.IsCanBeFusionMaterial,nil,e:GetHandler(),true)
	if gc then
		if not gc:IsCanBeFusionMaterial(e:GetHandler(),true) then return false end
		return (f1(gc) and mg:IsExists(f2,1,gc))
			or (f2(gc) and mg:IsExists(f1,1,gc)) end
	local g1=Group.CreateGroup() local g2=Group.CreateGroup() local fs=false
	local tc=mg:GetFirst()
	while tc do
		if f1(tc) then g1:AddCard(tc) if aux.FConditionCheckF(tc,chkf) then fs=true end end
		if f2(tc) then g2:AddCard(tc) if aux.FConditionCheckF(tc,chkf) then fs=true end end
		tc=mg:GetNext()
	end
	if chkf~=PLAYER_NONE then
		return fs and g1:IsExists(aux.FConditionFilterF2,1,nil,g2)
	else return g1:IsExists(aux.FConditionFilterF2,1,nil,g2) end
end
function c10173021.fsop(e,tp,eg,ep,ev,re,r,rp,gc,chkfnf)
	local f1=c10173021.filter1
	local f2=c10173021.filter2
	local chkf=bit.band(chkfnf,0xff)
	local g=eg:Filter(Card.IsCanBeFusionMaterial,nil,e:GetHandler(),true)
	if gc then
		local sg=Group.CreateGroup()
		if f1(gc) then sg:Merge(g:Filter(f2,gc)) end
		if f2(gc) then sg:Merge(g:Filter(f1,gc)) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		local g1=sg:Select(tp,1,1,nil)
		Duel.SetFusionMaterial(g1)
		return
	end
	local sg=g:Filter(aux.FConditionFilterF2c,nil,f1,f2)
	local g1=nil
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	if chkf~=PLAYER_NONE then
		g1=sg:FilterSelect(tp,aux.FConditionCheckF,1,1,nil,chkf)
	else g1=sg:Select(tp,1,1,nil) end
	local tc1=g1:GetFirst()
	sg:RemoveCard(tc1)
	local b1=f1(tc1)
	local b2=f2(tc1)
	if b1 and not b2 then sg:Remove(aux.FConditionFilterF2r,nil,f1,f2) end
	if b2 and not b1 then sg:Remove(aux.FConditionFilterF2r,nil,f2,f1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g2=sg:Select(tp,1,1,nil)
	g1:Merge(g2)
	Duel.SetFusionMaterial(g1)
end