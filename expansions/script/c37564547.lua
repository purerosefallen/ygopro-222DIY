--Nanahira OverDrive
local m=37564547
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.pendulum_level=7
cm.Senya_desc_with_nanahira=true
function cm.initial_effect(c)
	Senya.NanahiraExtraPendulum(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(37564765,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(cm.syncon)
	e1:SetTarget(cm.syntg)
	e1:SetOperation(cm.synop)
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetCost(Senya.SelfReleaseCost)
	e1:SetTarget(cm.hdtg)
	e1:SetOperation(cm.hdop)
	c:RegisterEffect(e1)
end
function cm.regcon(e)
	return e:GetHandler():GetFlagEffect(m-1000)>0
end
function cm.adcon(e)
	local c=e:GetHandler()
	return c:GetBattleTarget() and cm.regcon(e)
		and (Duel.GetCurrentPhase()==PHASE_DAMAGE or Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL)
end
function cm.adtg(e,c)
	return c==e:GetHandler():GetBattleTarget()
end
function cm.filter(c)
	return c:IsAbleToDeck()
end
function cm.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() and cm.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,cm.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function cm.operation1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	end
end
function cm.matfilter1(c,syncard)
	return (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsSynchroType(TYPE_TUNER) and c:IsCanBeSynchroMaterial(syncard)
end
function cm.matfilter2(c,syncard)
	return (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsSynchroType(TYPE_PENDULUM) and c:IsNotTuner() and c:IsRace(RACE_FAIRY) and c:IsCanBeSynchroMaterial(syncard)
end
function cm.matfilter3(c,syncard)
	return c:IsFaceup() and c:IsSynchroType(TYPE_TUNER) and c:IsCode(37564765) and c:IsCanBeSynchroMaterial(syncard)
end
function cm.matfilter4(c,syncard)
	return c:IsFaceup() and (c:GetOriginalType() & TYPE_TUNER)==0 and (c:GetOriginalRace() & RACE_FAIRY)~=0 and c:IsCode(37564765) and c:IsCanBeSynchroMaterial(syncard)
end
function cm.val(c,syncard)
	if c:IsLocation(LOCATION_SZONE) then
		return c:GetOriginalLevel()
	else
		return c:GetSynchroLevel(syncard)
	end
end
function cm.synfilter(c,syncard,lv,g2,g3,minc,maxc,tp)
	local tsg=c:IsHasEffect(EFFECT_HAND_SYNCHRO) and g3 or g2
	local f=c.tuner_filter
	if c.tuner_filter then tsg=tsg:Filter(f,nil) end
	return Senya.CheckGroup(tsg,cm.goal,Group.FromCards(c),minc,maxc,tp,lv,syncard,c)
end
function cm.goal(g,tp,lv,syncard,tuc)
	if Duel.GetLocationCountFromEx(tp,tp,g,syncard)<=0 then return false end
	if tuc:IsHasEffect(EFFECT_HAND_SYNCHRO) and g:IsExists(Card.IsLocation,2,tuc,LOCATION_HAND) then return false end
	local ct=g:GetCount()
	return g:CheckWithSumEqual(cm.val,lv,ct,ct,syncard)
end
function cm.syncon(e,c,tuner,mg)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local tp=c:GetControler()
	local minc=2
	local maxc=c:GetLevel()
	local g1=nil
	local g2=nil
	local g3=nil
	if mg then
		g1=mg:Filter(cm.matfilter1,nil,c)
		g2=mg:Filter(cm.matfilter2,nil,c)
		g3=g2:Clone()
	else
		g1=Duel.GetMatchingGroup(cm.matfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
		g2=Duel.GetMatchingGroup(cm.matfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
		g3=Duel.GetMatchingGroup(cm.matfilter2,tp,LOCATION_MZONE+LOCATION_HAND,LOCATION_MZONE,nil,c)
		local exg1=Duel.GetMatchingGroup(cm.matfilter3,tp,LOCATION_PZONE,0,nil,c)
		local exg2=Duel.GetMatchingGroup(cm.matfilter4,tp,LOCATION_PZONE,0,nil,c)
		g1:Merge(exg1)
		g2:Merge(exg2)
		g3:Merge(exg2)
	end
	local pe=Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_SMATERIAL)
	local lv=c:GetLevel()
	local sg=nil
	if tuner then
		return cm.matfilter1(c,tp) and cm.synfilter(tuner,c,lv,g2,g3,minc,maxc,tp)
	elseif pe then
		return cm.matfilter1(pe:GetOwner(),tp) and cm.synfilter(pe:GetOwner(),c,lv,g2,g3,minc,maxc,tp)
	else
		return g1:IsExists(cm.synfilter,1,nil,c,lv,g2,g3,minc,maxc,tp)
	end
end
function cm.syntg(e,tp,eg,ep,ev,re,r,rp,chk,c,tuner,mg)
	local minc=2
	local maxc=c:GetLevel()
	local g1=nil
	local g2=nil
	local g3=nil
	if mg then
		g1=mg:Filter(cm.matfilter1,nil,c)
		g2=mg:Filter(cm.matfilter2,nil,c)
		g3=g2:Clone()
	else
		g1=Duel.GetMatchingGroup(cm.matfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
		g2=Duel.GetMatchingGroup(cm.matfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
		g3=Duel.GetMatchingGroup(cm.matfilter2,tp,LOCATION_MZONE+LOCATION_HAND,LOCATION_MZONE,nil,c)
		local exg1=Duel.GetMatchingGroup(cm.matfilter3,tp,LOCATION_PZONE,0,nil,c)
		local exg2=Duel.GetMatchingGroup(cm.matfilter4,tp,LOCATION_PZONE,0,nil,c)
		g1:Merge(exg1)
		g2:Merge(exg2)
		g3:Merge(exg2)
	end
	local pe=Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_SMATERIAL)
	local lv=c:GetLevel()
	local tuc=nil
	if tuner then
		tuner=tuc
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		if not pe then
			local t1=g1:FilterSelect(tp,cm.synfilter,1,1,nil,c,lv,g2,g3,minc,maxc,tp)
			tuc=t1:GetFirst()
		else
			tuc=pe:GetOwner()
			Group.FromCards(tuc):Select(tp,1,1,nil)
		end
	end
	tuc:RegisterFlagEffect(m,RESET_EVENT+0x1fe0000,0,1)
	local tsg=tuc:IsHasEffect(EFFECT_HAND_SYNCHRO) and g3 or g2
	local f=c.tuner_filter
	if c.tuner_filter then tsg=tsg:Filter(f,nil) end
	local g=Senya.SelectGroup(tp,HINTMSG_SMATERIAL,tsg,cm.goal,Group.FromCards(tuc),minc,maxc,tp,lv,c,tuc)
	if g then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	else return false end
end
function cm.synop(e,tp,eg,ep,ev,re,r,rp,c,tuner,mg)
	local g=e:GetLabelObject()
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
	g:DeleteGroup()
end
function cm.hdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_HAND,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
end
function cm.hdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_HAND,nil)
	if g:GetCount()>0 then
		local sg=g:RandomSelect(tp,1)
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
end